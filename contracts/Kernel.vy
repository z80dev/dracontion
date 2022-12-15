# @version ^0.3.7

enum Actions:
     INSTALL_MODULE
     UPGRADE_MODULE
     ACTIVATE_POLICY
     DEACTIVATE_POLICY
     CHANGE_EXECUTOR
     CHANGE_ADMIN
     MIGRATE_KERNEL

################################################################
#                             VARS                             #
################################################################

executor: public(address)
admin: public(address)

################################################################
#                    DEPENDENCY MANAGEMENT                     #
################################################################

# Module Management
allKeycodes: public(bytes5[32])
getModuleForKeycode: public(HashMap[bytes5, address])
getKeycodeForModule: public(HashMap[address, bytes5])

# Module dependents data. Manages module dependencies for policies
moduleDependents: public(HashMap[bytes5, address[32]])
getDependentIndex: public(HashMap[bytes5, HashMap[address, uint256]])

# Module <> Policy Permissions. Policy -> Keycode -> Function Selector -> Permission
modulePermissions: public(HashMap[bytes5, HashMap[address, HashMap[bytes4, bool]]])

# List of all active policies
activePolicies: public(address[32])
getPolicyIndex: public(HashMap[address, uint256])

# Policy roles data
hasRole: public(HashMap[address, HashMap[bytes32, bool]])
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
