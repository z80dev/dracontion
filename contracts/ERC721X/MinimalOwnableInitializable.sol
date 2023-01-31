// SPDX-License-Identifier: MIT

pragma solidity >=0.8.7 <0.9.0;

// minimal; no modifier, just check _owner when needed
// not meant to be extremely useful, just to save me typing

contract MinimalOwnableInitializable {

    address public _owner;

    function initialize() internal {
        _owner = msg.sender;
    }

    function setOwner(address newOwner) external {
        require(_owner == msg.sender);
        _owner = newOwner;
    }

}
