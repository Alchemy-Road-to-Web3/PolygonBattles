//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// Contract deployed to: 0xd2b59bFe37B77166980C9aBB2C7eEFE12119A686

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;

    struct CharacterAttributes {
        string name;
        uint256 health;
        uint256 strength;
        uint256 agility;
        uint256 chakra;
    }

    mapping(uint256 => CharacterAttributes) public tokenIdToAttributes;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function generateCharacter(uint256 _tokenId)
        public
        returns (string memory)
    {
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            "<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>",
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="20%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Warrior",
            "</text>",
            '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Name: ",
            getAttribute(_tokenId, "name"),
            "</text>",
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Health: ",
            getAttribute(_tokenId, "health"),
            "</text>",
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Strength: ",
            getAttribute(_tokenId, "strength"),
            "</text>",
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Agility: ",
            getAttribute(_tokenId, "agility"),
            "</text>",
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',
            "Chakra: ",
            getAttribute(_tokenId, "chakra"),
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

    function getAttribute(uint256 _tokenId, string memory attributeName)
        public
        view
        returns (string memory)
    {
        CharacterAttributes memory attributes = tokenIdToAttributes[_tokenId];
        if (keccak256(bytes(attributeName)) == keccak256(bytes("name"))) {
            return attributes.name;
        } else if (keccak256(bytes(attributeName)) == keccak256(bytes("g"))) {
            return attributes.health.toString();
        } else if (
            keccak256(bytes(attributeName)) == keccak256(bytes("strength"))
        ) {
            return attributes.strength.toString();
        } else if (
            keccak256(bytes(attributeName)) == keccak256(bytes("agility"))
        ) {
            return attributes.agility.toString();
        } else if (
            keccak256(bytes(attributeName)) == keccak256(bytes("chakra"))
        ) {
            return attributes.chakra.toString();
        }
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

    function mint(string memory _name) public {
        tokenIds.increment();
        uint256 newItemId = tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToAttributes[newItemId] = CharacterAttributes(
            _name,
            10,
            10,
            10,
            10
        );
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId));
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this NFT to train it!"
        );
        uint256 newHealth = tokenIdToAttributes[tokenId].health + 5;
        uint256 newStrength = tokenIdToAttributes[tokenId].strength =
            tokenIdToAttributes[tokenId].strength +
            2;
        uint256 newAgility = tokenIdToAttributes[tokenId].agility =
            tokenIdToAttributes[tokenId].agility +
            2;
        uint256 newChakra = tokenIdToAttributes[tokenId].chakra =
            tokenIdToAttributes[tokenId].chakra +
            1;

        CharacterAttributes memory newAttributes = CharacterAttributes(
            tokenIdToAttributes[tokenId].name,
            newHealth,
            newStrength,
            newAgility,
            newChakra
        );

        tokenIdToAttributes[tokenId] = newAttributes;

        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
