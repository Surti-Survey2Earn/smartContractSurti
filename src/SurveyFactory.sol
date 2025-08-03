// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SurveyNFT is ERC721URIStorage, Ownable {
    uint256 public nextTokenId;

    constructor() ERC721("SurveyCompletionNFT", "SCNFT") {}

    function mint(address to, string memory uri) external onlyOwner returns (uint256) {
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        nextTokenId++;
        return tokenId;
    }
}

contract SurveyFactory is Ownable {
    struct Survey {
        address creator;
        uint256 maxResponses;
        uint256 rewardPerQuestion;
        uint256 questionCount;
        uint256 totalResponses;
        bool isActive;
    }

    struct UserProgress {
        bool submitted;
        bool claimed;
        uint256 xp;
        uint256 level;
    }

    IERC20 public rewardToken;
    SurveyNFT public nftContract;

    uint256 public baseXpPerQuestion = 10;
    uint256 public xpPerLevel = 100;

    mapping(uint256 => Survey) public surveys;
    mapping(uint256 => mapping(address => UserProgress)) public userProgress;
    uint256 public surveyCount;

    event SurveyCreated(uint256 indexed surveyId, address creator);
    event SurveySubmitted(uint256 indexed surveyId, address user, uint256 xpEarned);
    event RewardClaimed(uint256 indexed surveyId, address user, uint256 reward);

    constructor(address _token, address _nft) {
        rewardToken = IERC20(_token);
        nftContract = SurveyNFT(_nft);
    }

    function createSurvey(uint256 maxResponses, uint256 questionCount, uint256 rewardPerQuestion) external {
        surveys[surveyCount] = Survey({
            creator: msg.sender,
            maxResponses: maxResponses,
            rewardPerQuestion: rewardPerQuestion,
            questionCount: questionCount,
            totalResponses: 0,
            isActive: true
        });

        emit SurveyCreated(surveyCount, msg.sender);
        surveyCount++;
    }

    function submitSurvey(uint256 surveyId) external {
        Survey storage s = surveys[surveyId];
        require(s.isActive, "Survey is inactive");
        require(msg.sender != s.creator, "Creator cannot submit");
        require(!userProgress[surveyId][msg.sender].submitted, "Already submitted");
        require(s.totalResponses < s.maxResponses, "Max responses reached");

        userProgress[surveyId][msg.sender].submitted = true;
        s.totalResponses++;

        uint256 earnedXp = s.questionCount * baseXpPerQuestion;
        userProgress[surveyId][msg.sender].xp += earnedXp;

        // Level up
        uint256 currentLevel = userProgress[surveyId][msg.sender].level;
        uint256 totalXp = userProgress[surveyId][msg.sender].xp;
        uint256 newLevel = totalXp / xpPerLevel;
        if (newLevel > currentLevel) {
            userProgress[surveyId][msg.sender].level = newLevel;
        }

        emit SurveySubmitted(surveyId, msg.sender, earnedXp);
    }

    function claimReward(uint256 surveyId, string calldata nftUri) external {
        Survey storage s = surveys[surveyId];
        UserProgress storage progress = userProgress[surveyId][msg.sender];

        require(progress.submitted, "You must submit first");
        require(!progress.claimed, "Already claimed");

        // Hitung reward berdasarkan jumlah pertanyaan dan level
        uint256 baseReward = s.rewardPerQuestion * s.questionCount;
        uint256 bonus = (progress.level * baseReward) / 10; // 10% per level
        uint256 totalReward = baseReward + bonus;

        require(rewardToken.transfer(msg.sender, totalReward), "Reward failed");

        // Mint NFT
        nftContract.mint(msg.sender, nftUri);

        progress.claimed = true;

        emit RewardClaimed(surveyId, msg.sender, totalReward);
    }
}
