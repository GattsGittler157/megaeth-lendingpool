module.exports = {
  networks: {
    megaeth: {
      url: "https://carrot.megaeth.com/rpc",
      chainId: 6342,
      accounts: [process.env.DEPLOYER_PRIVATE_KEY],
    },
  },
  solidity: "0.8.17",
};
