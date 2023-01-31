// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity >=0.8.7 <0.9.0;

import "@ozu/token/ERC721/extensions/ERC721RoyaltyUpgradeable.sol";
import "@ozu/utils/introspection/ERC165StorageUpgradeable.sol";
import "../interfaces/IERC721X.sol";
import "./MinimalOwnableInitializable.sol";

contract ERC721XInitializable is ERC165StorageUpgradeable, ERC721RoyaltyUpgradeable, IERC721X, MinimalOwnableInitializable {

    address public minter;
    address public originAddress;
    uint32 public originChainId;
    bytes4 constant interfaceId = IERC721X.originChainId.selector ^ IERC721X.originAddress.selector;
    mapping(uint256 => string) public _tokenURIs;

    constructor() {
    _disableInitializers();
    }

    function initialize(string memory _name, string memory _symbol, address _originAddress, uint32 _originChainId, uint96 royaltyNumerator, address feeRecipient) public initializer {
        require(minter == address(0), "ALREADY_INIT");
        __ERC721_init(_name, _symbol);
        MinimalOwnableInitializable.initialize();
        _registerInterface(interfaceId);
        minter = msg.sender;
        originAddress = _originAddress;
        originChainId = _originChainId;
        _setDefaultRoyalty(feeRecipient, royaltyNumerator);
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
       return _tokenURIs[id];
    }

    function mint(address _to, uint256 _id, string memory _tokenURI) public {
        require(minter == msg.sender, "UNAUTH");
        _mint(_to, _id);
        _tokenURIs[_id] = _tokenURI;
    }

    function setMinter(address _minter) external {
        require(_owner == msg.sender);
        minter = _minter;
    }

    function burn(uint256 _id) public {
        require(minter == msg.sender, "UNAUTH");
        _burn(_id);
    }

    function supportsInterface(bytes4 _interfaceId) public view virtual override(ERC165StorageUpgradeable, ERC721RoyaltyUpgradeable) returns (bool) {
        return (ERC721RoyaltyUpgradeable.supportsInterface(_interfaceId) || ERC165StorageUpgradeable.supportsInterface(_interfaceId) );
    }
}
