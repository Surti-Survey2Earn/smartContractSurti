// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./SurveyRewardManager.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Survey {
    address public creator;
    string public title;
    uint256 public rewardPerResponse;
    uint256 public maxResponses;
    uint256 public totalResponses;

    IERC20 public rewardToken;
    SurveyRewardManager public rewardManager;

    mapping(address => bool) public hasClaimed;
    address[] public respondents;

    constructor(
        address _creator,
        string memory _title,
        uint256 _rewardPerResponse,
        uint256 _maxResponses,
        address _tokenAddress,
        address _rewardManager
    ) {
        creator = _creator;
        title = _title;
        rewardPerResponse = _rewardPerResponse;
        maxResponses = _maxResponses;
        rewardToken = IERC20(_tokenAddress);
        rewardManager = SurveyRewardManager(_rewardManager);
    }

    function submitSurvey(string memory answerHash) external {
        require(!hasClaimed[msg.sender], "Already submitted");
        require(totalResponses < maxResponses, "Max responses reached");

        hasClaimed[msg.sender] = true;
        respondents.push(msg.sender);
        totalResponses++;

        // XP + NFT + bonus reward
        rewardManager.addXP(msg.sender, 20);
        rewardManager.awardNFT(msg.sender, answerHash); // use answerHash as URI or IPFS reference

        uint256 multiplier = rewardManager.getBonusMultiplier(msg.sender);
        uint256 rewardAmount = (rewardPerResponse * multiplier) / 100;
        require(rewardToken.transfer(msg.sender, rewardAmount), "Transfer failed");
    }

    function getRespondents() external view returns (address[] memory) {
        return respondents;
    }
}
