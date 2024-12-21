// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LearnToEarnPlatform {
    // Project Metadata
    string public projectTitle = "Learn-to-Earn Streaming Platform";
    string public projectDescription = "A decentralized platform incentivizing learners with cryptocurrency rewards for contributing to problem-solving dApps.";
    string public contractAddress; // To be updated after deployment
    string public projectVision = "To democratize learning and incentivize participation in solving real-world problems through blockchain technology.";

    // Platform-specific structures
    struct Contributor {
        address walletAddress;
        uint256 totalContributions;
        uint256 rewardsEarned;
    }

    struct Problem {
        string description;
        address creator;
        uint256 rewardPool;
        bool isSolved;
    }

    mapping(address => Contributor) public contributors;
    mapping(uint256 => Problem) public problems;
    uint256 public problemCount;

    // Events
    event ProblemCreated(uint256 problemId, string description, address creator, uint256 rewardPool);
    event ContributionMade(address contributor, uint256 problemId, uint256 amount);
    event ProblemSolved(uint256 problemId, address solver);

    // Modifiers
    modifier onlyExistingProblem(uint256 problemId) {
        require(problemId < problemCount, "Problem does not exist");
        _;
    }

    // Key Features
    function createProblem(string memory description) external payable {
        require(msg.value > 0, "Reward pool must be greater than zero");
        problems[problemCount] = Problem({
            description: description,
            creator: msg.sender,
            rewardPool: msg.value,
            isSolved: false
        });
        emit ProblemCreated(problemCount, description, msg.sender, msg.value);
        problemCount++;
    }

    function contribute(uint256 problemId) external payable onlyExistingProblem(problemId) {
        require(msg.value > 0, "Contribution must be greater than zero");
        require(!problems[problemId].isSolved, "Problem is already solved");

        contributors[msg.sender].walletAddress = msg.sender;
        contributors[msg.sender].totalContributions += msg.value;
        contributors[msg.sender].rewardsEarned += msg.value;

        problems[problemId].rewardPool += msg.value;

        emit ContributionMade(msg.sender, problemId, msg.value);
    }

    function solveProblem(uint256 problemId) external onlyExistingProblem(problemId) {
        require(!problems[problemId].isSolved, "Problem is already solved");

        problems[problemId].isSolved = true;
        payable(msg.sender).transfer(problems[problemId].rewardPool);

        emit ProblemSolved(problemId, msg.sender);
    }

    function getContributorDetails(address contributor) external view returns (Contributor memory) {
        return contributors[contributor];
    }

    function getProblemDetails(uint256 problemId) external view returns (Problem memory) {
        return problems[problemId];
    }
}