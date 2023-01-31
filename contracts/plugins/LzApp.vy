interface ILayerZeroUserApplicationConfig:
    def setConfig(version: uint16, chainId: uint16, configType: uint256, config: Bytes[1024]): nonpayable
    def setSendVersion(version: uint16): nonpayable
    def setReceiveVersion(version: uint16): nonpayable
    def forceResumeReceive(srcChainId: uint16, srcAddress: Bytes[32]): nonpayable

interface ILayerZeroReceiver:
    def lzReceive(srcChainId: uint16, srcAddress: Bytes[32], nonce: uint64, payload: Bytes[1024]): nonpayable
