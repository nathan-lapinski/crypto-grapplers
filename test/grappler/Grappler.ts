import { expect } from "chai";
import { ethers } from "hardhat";

describe("GrapplerFactory contract", function () {
  it("Deployment should contain zero grapplers", async function () {
    const [owner] = await ethers.getSigners();

    const GrapplerF = await ethers.getContractFactory("GrapplerFactory");

    const hardhatGrapplerFactory = await GrapplerF.deploy();

    const grapplers = hardhatGrapplerFactory.grapplers;
    expect(grapplers.length).to.equal(0);
  });

  it("Adding a grappler should store it on chain", async function () {
    const [owner] = await ethers.getSigners();

    const GrapplerF = await ethers.getContractFactory("GrapplerFactory");

    const hardhatGrapplerFactory = await GrapplerF.deploy();

    await hardhatGrapplerFactory.createRandomGrappler("Garry Tonon");
    expect(await hardhatGrapplerFactory.getNumberOfGrapplers()).to.equal(1);

    await hardhatGrapplerFactory.createRandomGrappler("Gordon Ryan");
    expect(await hardhatGrapplerFactory.getNumberOfGrapplers()).to.equal(2);
  });
});
