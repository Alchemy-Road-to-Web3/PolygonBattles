//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// Contract deployed to: 0x7d353913B6F0c03485016474650423EA474a2eE5

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;

    mapping(uint256 => uint256) public tokenIdsToLevels;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 _tokenId)
        public
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Levels: ",
            getLevels(_tokenId),
            "</text>",
            "</svg>"
        );

        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getLevels(uint256 _tokenId) public view returns (string memory) {
        uint256 levels = tokenIdsToLevels[_tokenId];
        return levels.toString();
    }

    function getTokenURI(uint256 _tokenId) public returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            _tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(_tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        tokenIds.increment();
        uint256 newItemId = tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdsToLevels[newItemId] = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId));
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this NFT to train it!"
        );
        uint256 currentLevel = tokenIdsToLevels[tokenId];
        tokenIdsToLevels[tokenId] = currentLevel + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
