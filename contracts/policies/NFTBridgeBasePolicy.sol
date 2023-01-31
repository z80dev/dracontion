// SPDX-License-Identifier: AGPL-3.0-only
//

pragma solidity >=0.8.7 <0.9.0;

import "../KernelHelper.sol";
import "../modules/ERC721TransferManager.sol";
import "../modules/ERC721XManager.sol";
import "../modules/DepReg.sol";


abstract contract NFTBridgeBasePolicy is Policy {
    // Modules this Policy communicates with
    ERC721TransferManager public mgr;
    ERC721XManager public xmgr;
    DepositRegistry public registry;

    constructor(address _kernel) Policy(KernelSol(_kernel)) {}

    function configureDependencies() external override onlyKernel returns (Keycode[] memory dependencies) {
        dependencies = new Keycode[](3);
        dependencies[0] = Keycode.wrap(bytes5("DPREG"));
        dependencies[1] = Keycode.wrap(bytes5("NFTMG"));
        dependencies[2] = Keycode.wrap(bytes5("XFTMG"));
        _configureReads();
        return dependencies;
    }

    function _configureReads() internal {
        registry = DepositRegistry(getModuleAddress(Keycode.wrap(bytes5("DPREG"))));
        mgr = ERC721TransferManager(getModuleAddress(Keycode.wrap(bytes5("NFTMG"))));
        xmgr = ERC721XManager(getModuleAddress(Keycode.wrap(bytes5("XFTMG"))));
    }

    function requestPermissions()
        external
        view
        override
        onlyKernel
        returns (Permissions[] memory permissions)
    {
        permissions = new Permissions[](4);
        permissions[0] = Permissions(Keycode.wrap(bytes5("NFTMG")), 0x2d8bf0c5);
        permissions[1] = Permissions(Keycode.wrap(bytes5("XFTMG")), 0x9dc29fac);
        permissions[2] = Permissions(Keycode.wrap(bytes5("XFTMG")), 0x7cfc3ddf);
        permissions[3] = Permissions(Keycode.wrap(bytes5("DPREG")), 0xd9caed12);
        return permissions;
    }
}
