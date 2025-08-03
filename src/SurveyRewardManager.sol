// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SurveyRewardManager is ERC721URIStorage, Ownable {
    uint256 public tokenIdCounter = 1;

    struct UserProfile {
        uint256 xp;
        uint256 level;
    }

    mapping(address => UserProfile) public userProfiles;

    constructor() ERC721("SurveyCompletionNFT", "SCN") {}

    function awardNFT(address user, string memory tokenURI) external onlyOwner {
        uint256 newTokenId = tokenIdCounter++;
        _mint(user, newTokenId);
        _setTokenURI(newTokenId, tokenURI);
    }

    function addXP(address user, uint256 amount) external onlyOwner {
        userProfiles[user].xp += amount;
        _checkLevelUp(user);
    }

    function getLevel(address user) public view returns (uint256) {
        return userProfiles[user].level;
    }

    function _checkLevelUp(address user) internal {
        uint256 currentXP = userProfiles[user].xp;
        uint256 currentLevel = userProfiles[user].level;

        uint256 newLevel = currentXP / 100;
        if (newLevel > currentLevel) {
            userProfiles[user].level = newLevel;
        }
    }

    function getBonusMultiplier(address user) public view returns (uint256) {
        uint256 level = userProfiles[user].level;
        return 100 + level * 10; // 100% + 10% per level
    }
}
