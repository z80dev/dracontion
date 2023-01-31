implements: Policy

# External Interfaces
interface Counts:
    def increaseCount(addr: address): nonpayable
    def counts(arg0: address) -> uint256: view

kernel: address
func_sig: constant(bytes4) = 0x6526b04a # increaseCount(address)
keycode: immutable(bytes5)
isActive: public(bool)
counts: Counts

@external
def __init__(kernel: address):
    self.kernel = kernel
    keycode = convert(b"COUNT", bytes5)

@external
def inc():
    self.counts.increaseCount(msg.sender)

@external
def configureDependencies() -> DynArray[bytes5, 32]:
    self._onlyKernel()
    self.counts = Counts(Kernel(self.kernel).getModuleForKeycode(keycode))
    return [keycode]

@external
def requestPermissions() -> DynArray[Permissions, 32]:
    self._onlyKernel()
    return [Permissions({keycode: convert(b"COUNT", bytes5), funcSelector: func_sig})]

@external
def setActiveStatus(status: bool):
    self._onlyKernel()
    self.isActive = status


################################################################
#                      POLICY BOILERPLATE                      #
################################################################

@external
def changeKernel(kernel: address):
    assert msg.sender == self.kernel
    self.kernel = kernel

@internal
def _onlyKernel():
    assert msg.sender == self.kernel

@internal
def _onlyRole(role: bytes32):
    assert Kernel(self.kernel).hasRole(Policy(msg.sender), role)

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

# External Interfaces
interface Kernel:
    def executeAction(action: Actions, target: address): nonpayable
    def grantRole(role: bytes32, addr: address): nonpayable
    def revokeRole(role: bytes32, addr: address): nonpayable
    def executor() -> address: view
    def admin() -> address: view
    def allKeycodes(arg0: uint256) -> bytes5: view
    def getModuleForKeycode(arg0: bytes5) -> address: view
    def getKeycodeForModule(arg0: Module) -> bytes5: view
    def moduleDependents(arg0: bytes5, arg1: uint256) -> address: view
    def getDependentIndex(arg0: bytes5, arg1: Policy) -> uint256: view
    def modulePermissions(arg0: bytes5, arg1: Policy, arg2: bytes4) -> bool: view
    def activePolicies(arg0: uint256) -> address: view
    def getPolicyIndex(arg0: Policy) -> uint256: view
    def hasRole(arg0: Policy, arg1: bytes32) -> bool: view
    def isRole(arg0: bytes32) -> bool: view

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
