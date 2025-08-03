contract SurveyFactoryTest is Test {
    SurveyFactory factory;
    SurveyNFT nft;
    DummyToken token;

    address owner = address(this);
    address user = address(0xABCD);

    function setUp() public {
        token = new DummyToken();
        nft = new SurveyNFT(owner);
        factory = new SurveyFactory(address(token), address(nft), owner);

        // Transfer token to factory (simulasi fund reward)
        token.transfer(address(factory), 100 ether);
    }

    function testCreateSurvey() public {
        factory.createSurvey(10, 5, 1 ether);
        (address creator,, uint256 reward,,,) = factory.surveys(0);
        assertEq(creator, owner);
        assertEq(reward, 1 ether);
    }

    function testSubmitSurveyAndClaimReward() public {
        factory.createSurvey(10, 5, 1 ether);

        // Simulate user submitting the survey
        vm.prank(user); // run as user
        factory.submitSurvey(0);

        // XP & level calculated
        (, , , , , uint256 level) = factory.userProgress(0, user);
        assertEq(level, 0); // 5 * 10 XP = 50 XP → belum naik level (naik kalau 100 XP)

        // User claim reward
        vm.prank(user);
        factory.claimReward(0, "ipfs://sample-nft-uri");

        // Check if user received 5 ether (rewardPerQuestion * 5)
        uint256 userBalance = token.balanceOf(user);
        assertEq(userBalance, 5 ether); // no bonus karena level 0
    }

    function testLevelBonusApplied() public {
        factory.createSurvey(10, 10, 1 ether); // 10 * 10 XP = 100 XP → level 1

        vm.prank(user);
        factory.submitSurvey(0);

        (, , , , uint256 level) = factory.userProgress(0, user);
        assertEq(level, 1); // Should level up

        vm.prank(user);
        factory.claimReward(0, "ipfs://bonus-nft");

        uint256 expectedReward = 10 ether + (10 ether / 10); // 10 + 1 = 11
        assertEq(token.balanceOf(user), expectedReward);
    }

    function testCannotDoubleSubmitOrClaim() public {
        factory.createSurvey(10, 5, 1 ether);

        vm.prank(user);
        factory.submitSurvey(0);

        // Try to resubmit
        vm.prank(user);
        vm.expectRevert("Already submitted");
        factory.submitSurvey(0);

        vm.prank(user);
        factory.claimReward(0, "ipfs://nft");

        // Try to claim again
        vm.prank(user);
        vm.expectRevert("Already claimed");
        factory.claimReward(0, "ipfs://nft");
    }
}
