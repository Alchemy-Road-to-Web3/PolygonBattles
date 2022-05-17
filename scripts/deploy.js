const main = async () => {
  try {
    const contractFactory = await hre.ethers.getContractFactory("ChainBattles");
    const contract = await contractFactory.deploy();
    await contract.deployed();

    console.log(`Contract deployed to: ${contract.address}`);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

main();
