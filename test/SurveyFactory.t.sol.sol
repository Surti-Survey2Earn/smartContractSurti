// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Survey.sol";
import "../src/SurveyFactory.sol";

contract SurveyFactoryTest is Test {
    SurveyFactory public factory;
    address public creator = address(1);
    address public respondent = address(2);

    function setUp() public {
        factory = new SurveyFactory();
        vm.deal(creator, 10 ether);
        vm.deal(respondent, 10 ether);
    }

    function createSampleSurvey() internal returns (Survey) {
        vm.startPrank(creator);
        uint256 rewardPerResponse = 0.1 ether;
        uint256 maxResponses = 5;
        uint256 totalReward = rewardPerResponse * maxResponses;

        factory.createSurvey{value: totalReward}(
            "Judul Survei",
            "Deskripsi",
            rewardPerResponse,
            maxResponses
        );

        address[] memory surveys = factory.getAllSurveys();
        vm.stopPrank();
        return Survey(payable(surveys[0]));
    }

    function testCreateSurvey() public {
        vm.startPrank(creator);

        uint256 rewardPerResponse = 0.1 ether;
        uint256 maxResponses = 5;
        uint256 totalReward = rewardPerResponse * maxResponses;

        factory.createSurvey{value: totalReward}(
            "Judul Survei",
            "Deskripsi",
            rewardPerResponse,
            maxResponses
        );

        address[] memory surveys = factory.getAllSurveys();
        assertEq(surveys.length, 1);

        Survey survey = Survey(payable(surveys[0]));
        assertEq(survey.title(), "Judul Survei");
        assertEq(survey.creator(), creator);

        vm.stopPrank();
    }

    function testSubmitResponseAndClaimReward() public {
        Survey survey = createSampleSurvey();

        vm.startPrank(respondent);
        survey.submitResponse("hashed-answer");

        // Pastikan sudah submit
        (address respAddr,, bool rewarded) = survey.responses(respondent);
        assertEq(respAddr, respondent);
        assertEq(rewarded, false);

        // Klaim reward
        uint256 before = respondent.balance;
        survey.claimReward();
        uint256 afterClaim = respondent.balance;

        assertGt(afterClaim, before);
        vm.stopPrank();
    }

    function testCannotSubmitTwice() public {
        Survey survey = createSampleSurvey();

        vm.startPrank(respondent);
        survey.submitResponse("hash1");
        vm.expectRevert("Already responded");
        survey.submitResponse("hash2");
        vm.stopPrank();
    }

    function testCannotExceedMaxResponses() public {
        vm.startPrank(creator);
        factory.createSurvey{value: 0.1 ether}(
            "Survey",
            "Test",
            0.1 ether,
            1
        );
        Survey survey = Survey(payable(factory.getAllSurveys()[0]));
        vm.stopPrank();

        vm.startPrank(respondent);
        survey.submitResponse("hash");
        vm.stopPrank();

        address anotherUser = address(3);
        vm.deal(anotherUser, 1 ether);
        vm.startPrank(anotherUser);
        vm.expectRevert("Survey full");
        survey.submitResponse("other");
        vm.stopPrank();
    }

    function testCannotClaimTwice() public {
        Survey survey = createSampleSurvey();

        vm.startPrank(respondent);
        survey.submitResponse("hash");
        survey.claimReward();

        vm.expectRevert("Already claimed");
        survey.claimReward();
        vm.stopPrank();
    }

    function testClaimWithoutSubmitFails() public {
        Survey survey = createSampleSurvey();

        address nonRespondent = address(4);
        vm.deal(nonRespondent, 1 ether);
        vm.startPrank(nonRespondent);

        vm.expectRevert("No response");
        survey.claimReward();
        vm.stopPrank();
    }

    function testCreatorCannotSubmit() public {
        Survey survey = createSampleSurvey();

        vm.startPrank(creator);
        vm.expectRevert("Creator cannot submit");
        survey.submitResponse("invalid");
        vm.stopPrank();
    }
}
