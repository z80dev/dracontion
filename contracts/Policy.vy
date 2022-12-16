struct Permissions:
    keycode: bytes5
    funcSelector: bytes4

@external
def isActive() -> bool:
    pass

@external
def requestPermissions() -> DynArray[Permissions, 32]:
    pass

@external
def configureDependencies() -> DynArray[bytes5, 32]:
    pass

@external
def setActiveStatus(status: bool):
    pass

@external
def changeKernel(kernel: address):
    pass
