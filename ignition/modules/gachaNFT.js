const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("GachaGame", (m) => {
  const gachaNft = m.contract("GachaNFT");
  const gachaMarketplace = m.contract("GachaMarketPlace", [gachaNft]);
  const gachaMachine = m.contract("GachaMachine", [gachaNft]);
  return { gachaNft, gachaMachine, gachaMarketplace };
});