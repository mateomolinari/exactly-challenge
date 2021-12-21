const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Account balance: ", deployer.address);

    const ETH_Pool = await ethers.getContractFactory("ETHPool");
    const contract = await ETH_Pool.deploy();

    console.log("Contract address: ", contract.address);

}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });