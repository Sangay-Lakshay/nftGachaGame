// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract GachaMarketPlace {
    struct NFTInfo {
        address seller;
        uint256 price;
    }
    IERC721 private nftContract;

    mapping (uint256 => NFTInfo) private _listedNFTs;

    constructor(address nftAddress) {
        nftContract = IERC721(nftAddress);
    }

    function listedNFT(uint256 tokenId, uint256 price) external{
        require(nftContract.ownerOf(tokenId) == msg.sender, "Only the owner can list the NFT");
        require(price > 0, "Price must be greater than zero");
        require(nftContract.getApproved(tokenId) == address(this), "Marketplace is not approved to manage this NFT");
        _listedNFTs[tokenId] = NFTInfo({
            seller: msg.sender,
            price: price
        });
    }

    function buyNFT(uint256 tokenId) external payable {
        NFTInfo memory nftInfo = _listedNFTs[tokenId];
        require(nftContract.getApproved(tokenId) == address(this), "Marketplace is not approved to manage this NFT");
        require(nftContract.ownerOf(tokenId) != msg.sender, "You cannot buy your own NFT");
        require(msg.value == nftInfo.price, "Insufficient payment");

        // Transfer the NFT to the buyer
        nftContract.safeTransferFrom(nftInfo.seller, msg.sender, tokenId);
        
        // Transfer the payment to the seller
        payable(nftInfo.seller).transfer(msg.value);
        // Remove the NFT from the marketplace
        delete _listedNFTs[tokenId];
    }

    function getNFTInfo(uint256 tokenId) external view returns (NFTInfo memory) {
        return _listedNFTs[tokenId];
    }

    function isNFTListed(uint256 tokenId) external view returns (bool) {
        return _listedNFTs[tokenId].seller != address(0);
    }
}