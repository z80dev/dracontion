struct Permissions:
    keycode: bytes5
    funcSelector: bytes4

@external
def isActive() -> bool:
    return False

@external
def requestPermissions() -> DynArray[Permissions, 32]:
    return []

@external
def configureDependencies() -> DynArray[bytes5, 32]:
    return []

@external
def setActiveStatus(status: bool):
    pass

@external
def changeKernel(kernel: address):
    pass
