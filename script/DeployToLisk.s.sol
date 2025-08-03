// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/SurveyFactory.sol";
import "../src/SurveyNFT.sol";
import "../src/SurveyRewardManager.sol";

contract DeployToLisk is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("Deploying contracts with account:", deployer);
        console.log("Account balance:", deployer.balance);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // 1. Deploy Test Token
        TestToken token = new TestToken();
        console.log("TestToken deployed to:", address(token));
        
        // 2. Deploy NFT Contract
        SurveyNFT nft = new SurveyNFT(deployer);
        console.log("SurveyNFT deployed to:", address(nft));
        
        // 3. Deploy Reward Manager (optional, untuk survey standalone)
        SurveyRewardManager rewardManager = new SurveyRewardManager(deployer);
        console.log("SurveyRewardManager deployed to:", address(rewardManager));
        
        // 4. Deploy Survey Factory
        SurveyFactory factory = new SurveyFactory(
            address(token),
            address(nft),
            deployer
        );
        console.log("SurveyFactory deployed to:", address(factory));
        
        // 5. Transfer NFT ownership to factory
        nft.transferOwnership(address(factory));
        console.log("NFT ownership transferred to factory");
        
        // 6. Transfer some tokens to factory for rewards
        uint256 factoryTokens = 100000 * 10**18; // 100k tokens
        token.transfer(address(factory), factoryTokens);
        console.log("Transferred", factoryTokens / 10**18, "tokens to factory");
        
        vm.stopBroadcast();
        
        // Print summary
        console.log("\n=== DEPLOYMENT SUMMARY ===");
        console.log("Network: Lisk Sepolia Testnet");
        console.log("Deployer:", deployer);
        console.log("TestToken:", address(token));
        console.log("SurveyNFT:", address(nft));
        console.log("SurveyRewardManager:", address(rewardManager));
        console.log("SurveyFactory:", address(factory));
        console.log("\n=== NEXT STEPS ===");
        console.log("1. Verify contracts on block explorer");
        console.log("2. Test creating a survey");
        console.log("3. Fund factory with more tokens if needed");
    }
}

// Simple ERC20 untuk testing di testnet
contract TestToken {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    uint256 public totalSupply = 1000000 * 10**18;
    string public name = "Survey Test Token";
    string public symbol = "STT";
    uint8 public decimals = 18;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }
    
    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }
    
    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(allowance[from][msg.sender] >= amount, "Insufficient allowance");
        
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowance[from][msg.sender] -= amount;
        
        emit Transfer(from, to, amount);
        return true;
    }
}