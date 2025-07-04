// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract GachaMachine {
    IERC721 private nftContract;
    uint256 public pullPrice = 0.01 ether;  

    struct NFTInfo {
        uint256 tokenId;
        string rarity;
        uint256 probability;
    }

    NFTInfo[] public rarities;
    NFTInfo public resultNFT;
    
    address USER_0_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    constructor(address nftAddress) {
        nftContract = IERC721(nftAddress);
        // Initialize the gacha machine with a specific NFT
        rarities.push(NFTInfo(0, "Legendary", 3));
        rarities.push(NFTInfo(1, "Rare", 9));
        rarities.push(NFTInfo(2, "Rare", 9));
        rarities.push(NFTInfo(3, "Common", 20));
        rarities.push(NFTInfo(4, "Common", 20));
        rarities.push(NFTInfo(5, "Common", 20));
        rarities.push(NFTInfo(6, "Common", 20));
    }

    function pullGacha() external payable {
        uint256 tokenId;
        uint256 totalTokens = nftContract.balanceOf(USER_0_ADDRESS);
        require(msg.value == pullPrice, "Insufficient payment");
        require(totalTokens > 0, "No NFTs available for gacha pull");
        // Roll for a random NFT
        uint256 roll = _random() % 100;
        uint256 cumulativeProbability;
        for (uint256 i = 0; i < rarities.length; i++) {
            cumulativeProbability += rarities[i].probability;
            if (roll < cumulativeProbability) {
                tokenId = rarities[i].tokenId;
                break;
            }
        }
        // transfer the NFT to the player
        nftContract.safeTransferFrom(USER_0_ADDRESS, msg.sender, tokenId);
        payable(USER_0_ADDRESS).transfer(pullPrice);
        resultNFT = rarities[tokenId];
    }

    function _random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(
            block.timestamp, 
            block.prevrandao, 
            msg.sender
        )));
    }

    function getLastGachaResult() external view returns (NFTInfo memory) {
        return resultNFT;
    }
}