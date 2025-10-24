const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contracts with:", deployer.address);

  const MockToken = await hre.ethers.getContractFactory("MockToken");
  const mockToken = await MockToken.deploy(hre.ethers.parseEther("1000000"));
  await mockToken.waitForDeployment();
  console.log("MockToken deployed to:", await mockToken.getAddress());

  const LendingPool = await hre.ethers.getContractFactory("LendingPool");
  const pool = await LendingPool.deploy(await mockToken.getAddress());
  await pool.waitForDeployment();
  console.log("LendingPool deployed to:", await pool.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
