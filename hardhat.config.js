require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ethers")

let secret = require("./secret.json");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: secret.url,
      accounts: [secret.key]
    }
  },
  etherscan: {
    apiKey: secret.etherscan
  }
};

task(
  "balance",
  "Prints the current contract balance",
  async (_, { ethers }) => {
    await ethers.provider.getBalance("0xF65eD1165627BD4eB0fEFdfC5e9856D4b2d867d8").then((balance) => {
      console.log("Current balance for contract: ", ethers.utils.formatEther(balance));
    });
  }
);