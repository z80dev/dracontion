# @version ^0.3.7

# External Interfaces
interface Module:
    def KEYCODE() -> bytes5: pure
    def SETUP(): nonpayable
    def changeKernel(kernel: address): nonpayable

interface Policy:
    def isActive() -> bool: nonpayable
    def requestPermissions() -> DynArray[Permissions, 32]: nonpayable
    def configureDependencies() -> DynArray[bytes5, 32]: nonpayable
    def setActiveStatus(status: bool): nonpayable
    def changeKernel(kernel: address): nonpayable



enum Actions:
     INSTALL_MODULE
     UPGRADE_MODULE
     ACTIVATE_POLICY
     DEACTIVATE_POLICY
     CHANGE_EXECUTOR
     CHANGE_ADMIN
     MIGRATE_KERNEL

struct Permissions:
    keycode: bytes5
    funcSelector: bytes4

################################################################
#                             VARS                             #
################################################################

executor: public(address)
admin: public(address)

################################################################
#                    DEPENDENCY MANAGEMENT                     #
################################################################

# Module Management
allKeycodes: public(DynArray[bytes5, 32])
getModuleForKeycode: public(HashMap[bytes5, Module])
getKeycodeForModule: public(HashMap[Module, bytes5])

# Module dependents data. Manages module dependencies for policies
moduleDependents: public(HashMap[bytes5, DynArray[Policy, 32]])
getDependentIndex: public(HashMap[bytes5, HashMap[Policy, uint256]])

# Module <> Policy Permissions. Policy -> Keycode -> Function Selector -> Permission
modulePermissions: public(HashMap[bytes5, HashMap[Policy, HashMap[bytes4, bool]]])

# List of all active policies
activePolicies: public(DynArray[Policy, 32])
getPolicyIndex: public(HashMap[Policy, uint256])

# Policy roles data
hasRole: public(HashMap[Policy, HashMap[bytes32, bool]])
isRole: public(HashMap[bytes32, bool])

@external
def __init__():
    self.executor = msg.sender
    self.admin = msg.sender

@internal
def _onlyAdmin():
    assert msg.sender == self.admin

@internal
def _onlyExecutor():
    assert msg.sender == self.executor

@external
def executeAction(action: Actions, target: address):
    self._onlyExecutor()
    if action == Actions.INSTALL_MODULE:
        self._installModule(target)
    elif action == Actions.UPGRADE_MODULE:
        self._upgradeModule(target)
    elif action == Actions.ACTIVATE_POLICY:
        self._activatePolicy(target)
    elif action == Actions.DEACTIVATE_POLICY:
        self._deactivatePolicy(target)
    elif action == Actions.MIGRATE_KERNEL:
        self._migrateKernel(target)
    elif action == Actions.CHANGE_EXECUTOR:
        self.executor = target
    elif action == Actions.CHANGE_ADMIN:
        self.admin = target

@internal
def _installModule(module: address):
    keycode: bytes5 = Module(module).KEYCODE()
    oldModule: Module = self.getModuleForKeycode[keycode]

    assert self.getModuleForKeycode[keycode] == empty(Module), "module installed"

    self.getModuleForKeycode[keycode] = Module(module)
    self.getKeycodeForModule[Module(module)] = keycode
    self.allKeycodes.append(keycode)

    Module(module).SETUP()


@internal
def _upgradeModule(module: address):
    keycode: bytes5 = Module(module).KEYCODE()
    oldModule: Module = self.getModuleForKeycode[keycode]

    assert not oldModule == empty(Module)
    assert not oldModule == Module(module)

    self.getKeycodeForModule[oldModule] = 0x0000000000
    self.getKeycodeForModule[Module(module)] = keycode
    self.getModuleForKeycode[keycode] = Module(module)

    Module(module).SETUP()

    self._reconfigurePolicies(keycode)

@internal
def _activatePolicy(policy: address):
    assert not Policy(policy).isActive()

    # grant permissions for policy to access restricted module functions
    requests: DynArray[Permissions, 32] = Policy(policy).requestPermissions()
    self._setPolicyPermissions(policy, requests, True)

    # add policy to list of active policies
    self.activePolicies.append(Policy(policy))
    self.getPolicyIndex[Policy(policy)] = len(self.activePolicies) - 1

    # record module dependencies
    dependencies: DynArray[bytes5, 32] = Policy(policy).configureDependencies()

    for keycode in dependencies:
       self.moduleDependents[keycode].append(Policy(policy))
       self.getDependentIndex[keycode][Policy(policy)] = len(self.moduleDependents[keycode]) - 1

    Policy(policy).setActiveStatus(True)

@internal
def _deactivatePolicy(policy: address):
    assert Policy(policy).isActive()

    # revoke permissions
    requests: DynArray[Permissions, 32] = Policy(policy).requestPermissions()
    self._setPolicyPermissions(policy, requests, False)

    index: uint256 = self.getPolicyIndex[Policy(policy)]
    lastPolicy: Policy = self.activePolicies[len(self.activePolicies) - 1]

    self.activePolicies[index] = lastPolicy
    self.activePolicies.pop()
    self.getPolicyIndex[lastPolicy] = index

    # may be unnecessary
    self.getPolicyIndex[Policy(policy)] = 0

    self._pruneFromDependents(policy)

    Policy(policy).setActiveStatus(False)

# WARNING: ACTION WILL BRICK THIS KERNEL. All functionality will move to the new kernel
# New kernel must add in all of the modules and policies via executeAction
# NOTE: Data does not get cleared from this kernel
@internal
def _migrateKernel(kernel: address):
    for keycode in self.allKeycodes:
        module: Module = self.getModuleForKeycode[keycode]
        module.changeKernel(kernel)

    for policy in self.activePolicies:
        # Deactivate before changing kernel
        policy.setActiveStatus(False)
        policy.changeKernel(kernel)

@internal
def _reconfigurePolicies(keycode: bytes5):
    dependents: DynArray[Policy, 32] = self.moduleDependents[keycode]
    for dep in dependents:
        dep.configureDependencies()

@internal
def _setPolicyPermissions(policy: address, requests: DynArray[Permissions, 32], enabled: bool):
    for req in requests:
        self.modulePermissions[req.keycode][Policy(policy)][req.funcSelector] = enabled

@internal
def _pruneFromDependents(policy: address):
    dependencies: DynArray[bytes5, 32] = Policy(policy).configureDependencies()
    for keycode in dependencies:
        origIndex: uint256 = self.getDependentIndex[keycode][Policy(policy)]
        lastPolicy: Policy = self.moduleDependents[keycode][len(self.moduleDependents[keycode]) - 1]

        self.moduleDependents[keycode][origIndex] = lastPolicy
        self.moduleDependents[keycode].pop()

        self.getDependentIndex[keycode][lastPolicy] = origIndex

@external
def grantRole(role: bytes32, addr: address):
    self._onlyAdmin()
    assert not self.hasRole[Policy(addr)][role]
    self.hasRole[Policy(addr)][role] = True

@external
def revokeRole(role: bytes32, addr: address):
    self._onlyAdmin()
    assert self.hasRole[Policy(addr)][role]
    self.hasRole[Policy(addr)][role] = False
