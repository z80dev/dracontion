// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity >=0.8.7 <0.9.0;

import "../ERC721.sol";
import "../interfaces/IERC721X.sol";
import "./MinimalOwnable.sol";

contract ERC721X is ERC721, IERC721X, MinimalOwnable {

    address public minter;
    address public immutable originAddress;
    uint32 public immutable originChainId;
    bytes4 constant interfaceID = 0xefd00bbc;
    mapping(uint256 => string) public _tokenURIs;

    constructor(string memory _name, string memory _symbol, address _originAddress, uint32 _originChainId) ERC721(_name, _symbol) MinimalOwnable() {
        minter = msg.sender;
        originAddress = _originAddress;
        originChainId = _originChainId;
    }

    function setMinter(address _minter) external {
        require(_owner == msg.sender);
        minter = _minter;
    }

    function supportsInterface(bytes4 _interfaceId) public view virtual override returns (bool) {
        return (_interfaceId == interfaceID || super.supportsInterface(_interfaceId));
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
       return _tokenURIs[id];
    }

    function mint(address _to, uint256 _id, string memory _tokenURI) public {
        require(minter == msg.sender, "UNAUTH");
        _safeMint(_to, _id);
        _tokenURIs[_id] = _tokenURI;
    }

    function burn(uint256 _id) public {
        require(minter == msg.sender, "UNAUTH");
        _burn(_id);
    }
}
