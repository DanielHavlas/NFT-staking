const main = async () => {
  const NFTFactory = await hre.ethers.getContractFactory('NFT')
  const NFTContract = await NFTFactory.deploy()
  await NFTContract.deployed()

    const NFTStakingFactory = await hre.ethers.getContractFactory('NFTStaking')
    const NFTStakingContract = await NFTStakingFactory.deploy(NFTContract.address, 'QmVdeVz6NNvrD9keQ1QrQ3Gzga5taDoeUbVvuR3qCWZMje')
    await NFTStakingContract.deployed()
    console.log('Contract deployed to: ', NFTStakingContract.address, )
    console.log('NFT Contract deployed to: ', NFTContract.address )
}


const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();