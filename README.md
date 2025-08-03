# Surti - Survey2Earn Platform 🧠

> A Web3 platform that empowers communities to earn rewards by completing surveys, helping AI and Web3 projects gain quality insights.

[![Lisk](https://img.shields.io/badge/Built_on-Lisk-blue)](https://lisk.com/)
[![Solidity](https://img.shields.io/badge/Solidity-^0.8.19-green)](https://soliditylang.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 🌟 Overview

Surti is a decentralized survey platform that connects Web3/AI projects with communities to obtain quality data and insights. The platform uses a token-based reward system and reputation scoring to ensure credible and high-quality data collection.

## 🔍 Problem & Solution

### 🚨 Problems We Solve

- **Expensive Traditional Surveys**: Web3 & AI projects struggle to get community data at affordable costs
- **Irrelevant Data**: Conventional surveys often produce data that's not relevant to Web3 context
- **Limited Web3 Earning**: Many users want to earn from Web3 without technical skills or trading
- **Quality Control**: Difficult to ensure respondent quality and answer authenticity

### ✅ Our Solution

- **Affordable Survey Platform**: Low-cost survey creation on Lisk blockchain
- **Community-Driven Rewards**: Users earn token rewards for quality participation
- **Reputation System**: Credible respondents get higher reputation and increased earning potential
- **Anti-Sybil Protection**: Multi-layer verification system to prevent bots and fake responses

## 🧩 Key Features

| Feature | Description |
|---------|-------------|
| 📝 **Survey Builder** | Drag & drop survey creation interface |
| 💰 **Reward Pool** | Smart contract-based token distribution |
| 👤 **Reputation System** | XP and level-based credibility scoring |
| 🛡️ **Anti-Sybil Protection** | Wallet age check, captcha, social proof |
| 🔍 **Analytics Dashboard** | Real-time survey insights and visualization |
| 🌍 **Multi-language Support** | Global community accessibility |
| 🏆 **NFT Certificates** | Proof of participation and achievements |

## 🏗️ Technical Architecture

### Smart Contracts

```
Surti Platform
├── SurveyFactory.sol      # Main survey management contract
├── SurveyNFT.sol         # NFT certificates for completions
├── SurveyRewardManager.sol # XP and reputation management
└── TestToken.sol         # Platform utility token (STT)
```

### Core Components

1. **Survey Factory**: Creates and manages surveys with reward pools
2. **Reputation Engine**: Tracks user XP, levels, and credibility scores
3. **Anti-Sybil Filter**: Validates user authenticity and prevents gaming
4. **Reward Distribution**: Automated token payments based on quality metrics

## 🎯 Target Users

### 🏢 Survey Creators (B2B)
- **Web3 Projects**: Market research, product feedback, community opinions
- **AI Companies**: Data labeling, model training, user preference collection
- **DAOs**: Governance insights, member sentiment analysis

### 👥 Survey Participants (B2C)
- **Crypto Community**: Degens, holders, traders seeking passive income
- **Web3 Enthusiasts**: Non-technical users wanting to contribute and earn
- **Global Users**: Anyone interested in blockchain-based earning opportunities

## 💰 Business Model

### Revenue Streams
- **Survey Creation Fees**: Small fee for posting surveys
- **Premium Analytics**: Advanced dashboard and insights tools
- **B2B Subscriptions**: Enterprise features for large-scale research

### Value Propositions
- **For Creators**: High-quality, verified community data at low cost
- **For Participants**: Earn tokens while contributing to Web3 ecosystem
- **For Platform**: Sustainable tokenomics with utility-driven demand

## 🚀 Getting Started

### Prerequisites

- [Foundry](https://getfoundry.sh/) for smart contract development
- Node.js and npm for frontend development
- Lisk Sepolia testnet ETH for deployment

### Quick Deploy

```bash
# Clone repository
git clone https://github.com/Surti-Survey2Earn/smartContractSurti.git
cd smartContractSurti

# Install dependencies
forge install
npm install

# Set up environment
cp .env.example .env
# Add your PRIVATE_KEY and RPC_URL

# Deploy to Lisk Sepolia
forge script script/DeployToLisk.s.sol --rpc-url $LISK_SEPOLIA_RPC_URL --broadcast
```

### Contract Addresses (Lisk Sepolia)

```
TestToken (STT):      0x4C1B34C6650B63B8c43559a2bbB2CdA0eE5711ed
SurveyNFT:           0xECc8BACDBED871EA0eC6310657e1b5725d0Ab814
SurveyFactory:       0x3737f2DB9c9a68d4Ad8bCc6f092AEe5dbc21a5c1
RewardManager:       0x7Ca15Feda3a17B215035C984c2CAB8ee68f9416c
```

## 🎮 How It Works

### For Survey Creators

1. **Connect Wallet** → **Create Survey** → **Fund Reward Pool**
2. **Set Parameters**: Max responses, reward per response, quality filters
3. **Launch Survey** → **Monitor Real-time Results** → **Download Insights**

### For Participants

1. **Browse Available Surveys** → **Check Reward & Requirements**
2. **Complete Survey** → **Submit Responses** → **Earn XP**
3. **Claim Rewards** → **Receive Tokens + NFT** → **Build Reputation**

### Reward Calculation

```solidity
Base Reward = questionsCount × rewardPerQuestion
Level Bonus = (userLevel × baseReward) / 10
Final Reward = baseReward + levelBonus
XP Earned = questionsCount × 10
```

## 🛡️ Anti-Sybil Measures

### Multi-Layer Protection

- **Wallet Age Verification**: Minimum wallet age and transaction history
- **Social Proof Integration**: Discord/Twitter account linking
- **Behavioral Analysis**: Response pattern detection
- **Staking Requirements**: Small token stake for high-value surveys
- **Reputation Weighting**: Higher rewards for established users

### Quality Control

- **Attention Checks**: Hidden validation questions
- **Response Time Analysis**: Flag suspiciously fast completions
- **Cross-Reference Validation**: Compare answers across similar surveys
- **Community Reporting**: User-driven quality feedback

## 📊 Use Cases

### 🧠 AI Training Data
```
AI Project needs labeled images
→ Create survey with image classification tasks
→ Community labels data for rewards
→ High-quality training dataset generated
```

### 📈 Market Research
```
Web3 startup testing new product concept
→ Survey target demographics in crypto community
→ Get verified feedback from real users
→ Data-driven product decisions
```

### 🗳️ DAO Governance
```
DAO considering major protocol change
→ Survey members for detailed opinions
→ Weighted voting based on reputation
→ Informed governance decisions
```

## 🔧 Development

### Smart Contract Testing

```bash
# Run all tests
forge test

# Test with gas reporting
forge test --gas-report

# Test specific functions
forge test --match-test testSurveyCreation -vvv
```

### Frontend Development

```bash
# Start development server
npm run dev

# Build for production
npm run build

# Run tests
npm test
```


## 🔗 Links & Resources

- [Live Platform](https://surti.app) (Coming Soon)
- [TestToken on Blockscout](https://sepolia-blockscout.lisk.com/address/0x4C1B34C6650B63B8c43559a2bbB2CdA0eE5711ed)
- [SurveyFactory Contract](https://sepolia-blockscout.lisk.com/address/0x3737f2DB9c9a68d4Ad8bCc6f092AEe5dbc21a5c1)
- [SurveyNFT Contract](https://sepolia-blockscout.lisk.com/address/0xECc8BACDBED871EA0eC6310657e1b5725d0Ab814)
- [Documentation](https://docs.surti.app) (Coming Soon)
- [Discord Community](https://discord.gg/surti) (Coming Soon)
- [Twitter](https://twitter.com/surti_platform) (Coming Soon)
- [Lisk Grant Program](https://lisk.com/grants)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Lisk Foundation for blockchain infrastructure
- OpenZeppelin for secure smart contract libraries
- Our amazing beta testing community

---

**Built with ❤️ on Lisk | Empowering Web3 Communities Through Surveys**