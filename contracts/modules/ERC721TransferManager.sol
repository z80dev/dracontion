// SPDX-License-Identifier: MIT

// This contract acts as the universal NFT mover
// this way, users only have to approve one contract to move their NFTs through
// any of our other contracts

pragma solidity >=0.8.7 <0.9.0;

import "../KernelHelper.sol";
import "../ERC721.sol";

contract ERC721TransferManager is Module {
    constructor(KernelSol kernel_) Module(kernel_) {}

    function KEYCODE() public pure override returns (Keycode) {
        return Keycode.wrap(bytes5("NFTMG")); // NFT Manager
    }

    function safeTransferFrom(
        address collection,
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external permissioned {
        ERC721(collection).safeTransferFrom(from, to, tokenId, data);
    }
}
