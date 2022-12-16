from .. import Module as Module
from .. import Kernel as Kernel
from .. import Policy as Policy

implements: Policy

kernel: address
func_sig: constant(bytes4) = 0x6526b04a # increaseCount(address)
isActive: public(bool)

@external
def __init__(kernel: address):
    self.kernel = kernel

@external
def configureDependencies() -> DynArray[bytes5, 32]:
    self._onlyKernel()
    return [convert(b"COUNT", bytes5)]


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
