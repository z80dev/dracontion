import Kernel as Kernel

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


implements: Module

kernel: address
keycode: constant(bytes5) = 0x434F554E54 # b"COUNT"
counts: public(HashMap[address, uint256])

@external
def __init__(kernel: address):
    self.kernel = kernel

@external
def SETUP():
    pass

@external
def increaseCount(addr: address):
    self._checkPolicyAuth()
    self.counts[addr] = self.counts[addr] + 1

################################################################
#                      MODULE BOILERPLATE                      #
################################################################

@external
def KEYCODE() -> bytes5:
    return keycode

@internal
def _checkPolicyAuth():
    func: bytes4 = convert(slice(msg.data, 0, 4), bytes4)
    assert Kernel(self.kernel).modulePermissions(keycode, Policy(msg.sender), func)

@internal
def _onlyKernel():
    assert msg.sender == self.kernel

@external
def changeKernel(kernel: address):
    assert msg.sender == self.kernel
    self.kernel = kernel

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
