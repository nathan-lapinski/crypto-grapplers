// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GrapplerFactory is Ownable {
    // aabbccddeeffgghh
    // where the following digits map. This will change as the rules of the game evolve. This is  v0.0
    /**
  | Skill | description | notes                                                                 |
  |-------|-------------|-----------------------------------------------------------------------|
  | aa    | leglocks    | Have the ability to win quickly. Can beat strength                    |
  | bb    | wrestling   | Useful skill in general                                               |
  | cc    | strength    | Useful skill in general. Can compete against technique at same level  |
  | dd    | defense     | Reduces odds of being submitted                                       |
  | ee    | technique   | Useful skill in general. Can compete against strength at higher level |
  | ff    | passing     | Great for offense                                                     |
  | gg    | guard       | Great for defense                                                     |
   */
    uint256 skillDigits = 16;
    uint256 skillModulus = 10**skillDigits;

    struct Grappler {
        string name;
        uint256 skills; // the bits of this uint should map to skills, such as leglocks, guard, wrestling, speed, etc
        uint32 level;
        uint16 winCount;
        uint16 lossCount;
        // TODO: Add a Coach struct (array?) which can update the grapplers skills
    }

    Grappler[] public grapplers;

    mapping(uint256 => address) public grapplerToOwner;
    mapping(address => uint256) ownerGrapplerCount;

    function _createGrappler(string memory _name, uint256 _skills) internal {
        grapplers.push(Grappler(_name, _skills, 1, 0, 0));
        uint256 id = grapplers.length - 1;
        grapplerToOwner[id] = msg.sender;
        ownerGrapplerCount[msg.sender]++;
    }

    function _generateRandomSkills(string memory _str) private view returns (uint256) {
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % skillModulus;
    }

    function createRandomGrappler(string memory _name) public {
        // For now, limit to one creation per user
        require(ownerGrapplerCount[msg.sender] == 0);
        uint256 randSkills = _generateRandomSkills(_name);
        randSkills = randSkills - (randSkills % 100);
        _createGrappler(_name, randSkills);
    }
}
