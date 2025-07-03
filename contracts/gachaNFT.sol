// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GachaNFT is ERC721URIStorage, Ownable {
    uint256 private nextTokenId;

    string[] private nftURIs = [
        'bafkreic64mfmetvazqfqipbtckiwtdjcobu4hhe54xr3azpqwh5pyrdgne',
        'bafkreiarvbb5fo5qimbtfqms3pvdjgnub7tbbonpb3zv65eijhkmh5rchu',
        'bafkreibfrsh3gbnyz24fapgaja5sebx2fnlpbep56s3gt2hagwpxric6oi',
        'bafkreihupj62yqa4avj2wzk4pguuflpvkgmh4n2yhkmy4p6a5mts5m7jfe',
        'bafkreibfcg5njbpufkmiyzwfk2tzm5vy7d74eme4re3qxf2pf7ueozwlfu',
        'bafkreigzllcv5ha3zz33sbqtasmyaxxxxypbttlzfozcx34egbifqoespe',
        'bafkreigcqurfcwpztto3bi4s2wfvsxz47fkrqdrisb2g2yhi5vosol4fp4'
        ];

    constructor() ERC721("Gacha Game", "GachaNFT") Ownable(msg.sender) {
        for (uint256 i = 0; i < nftURIs.length; i++) {
            _mint(msg.sender, nextTokenId);
            _setTokenURI(nextTokenId, nftURIs[i]);
            nextTokenId++;
        }
    }

    function mintNFT(address owner, string memory tokenURI) external onlyOwner {
        uint256 tokenId = nextTokenId++;
        _mint(owner, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    function totalNFTs() external view returns (uint256) {
        return nextTokenId;
    }
}