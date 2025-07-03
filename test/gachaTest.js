const {
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { expect } = require("chai");

describe("Gacha Game", () => {
  async function deployTTPLTContract() {
    const factory = await ethers.getContractFactory("GachaNFT");
    const nft = await factory.deploy();
    const factoryMarketplace = await ethers.getContractFactory("GachaMarketPlace");
    const nftMarketplace = await factoryMarketplace.deploy(nft);
    const factoryMachine = await ethers.getContractFactory("GachaMachine");
    const gachaMachine = await factoryMachine.deploy(nft);
    const accounts = await ethers.getSigners();
    return { nft, nftMarketplace, gachaMachine, accounts };
  }

  describe("Test NFT", function () {
    it("Mint NFT", async function () {
      const { nft, accounts } = await loadFixture(deployTTPLTContract);
      await nft.mintNFT(accounts[0], "001");
      expect(await nft.totalNFTs()).to.equal(8);
    });
  });

  describe("Test Gacha Machine", function () {
    it("Should roll a random NFT", async function () {
      const { nft, accounts, gachaMachine } = await loadFixture(deployTTPLTContract);
      var initialBalance = await nft.balanceOf(accounts[0]);
      var initialBalance1 = await nft.balanceOf(accounts[1]);
      await nft.setApprovalForAll(gachaMachine, true);
      await gachaMachine.connect(accounts[1]).pullGacha({ value: ethers.parseEther("0.01") });
      const newBalance = await nft.balanceOf(accounts[0]);
      const newBalance1 = await nft.balanceOf(accounts[1]);
      expect(newBalance).to.equal(Number(initialBalance) - 1);
      expect(newBalance1).to.equal(Number(initialBalance1) + 1);
    });
  });

  describe("Test marketplace", function () {
    it("Should approve NFT to marketplace", async function () {
      const { nft, nftMarketplace, accounts } = await loadFixture(deployTTPLTContract);
      await nft.mintNFT(accounts[0], "001");
      await nft.approve(nftMarketplace, 0);
      expect(await nft.getApproved(0)).to.equal(nftMarketplace);
    });

    it("Should list NFT for sale", async function () {
        const { nft, nftMarketplace, accounts } = await loadFixture(deployTTPLTContract);
        await nft.mintNFT(accounts[0], "001");
        await nft.approve(nftMarketplace, 0);
        await nftMarketplace.listedNFT(0, ethers.parseEther("1"));
        const listing = await nftMarketplace.getNFTInfo(0);
        expect(listing.price).to.equal(ethers.parseEther("1"));
        expect(listing.seller).to.equal(accounts[0]);
    });

    it("Should buy NFT", async function () {
      const { nft, nftMarketplace, accounts } = await loadFixture(deployTTPLTContract);
      await nft.mintNFT(accounts[0], "001");
      await nft.approve(nftMarketplace, 0);
      await nftMarketplace.listedNFT(0, ethers.parseEther("1"));
      await nftMarketplace.connect(accounts[1]).buyNFT(0, { value: ethers.parseEther("1") });
      expect(await nft.ownerOf(0)).to.equal(accounts[1]);
    });
  });
});