from .. import Module as Module
from .. import Kernel as Kernel
from .. import Policy as Policy

implements: Module

kernel: address
keycode: constant(bytes5) = 0x434F554EF4 # b"COUNT"
counts: public(HashMap[address, uint256])

@external
def increaseCount(addr: address):
    func: bytes4 = convert(slice(msg.data, 0, 4), bytes4)
    assert Kernel(self.kernel).modulePermissions(keycode, Policy(msg.sender), func)
    self.counts[addr] = self.counts[addr] + 1

@external
def KEYCODE() -> bytes5:
    return keycode

@external
def SETUP():
    pass

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
