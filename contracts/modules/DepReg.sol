// SPDX-License-Identifier: MIT

pragma solidity >=0.8.7 <0.9.0;

import "../KernelHelper.sol";
import "../ERC721.sol";

contract DepositRegistry is
    // IDepositRegistry,
    ERC721TokenReceiver,
    Module
{
    function KEYCODE() public pure override returns (Keycode) {
        return Keycode.wrap(bytes5("DPREG"));
    }

    constructor(KernelSol kernel_) Module(kernel_) {}

    function withdraw(
        address collection,
        address recipient,
        uint256 tokenId
    ) external permissioned {
        ERC721(collection).safeTransferFrom(address(this), recipient, tokenId);
    }
}
