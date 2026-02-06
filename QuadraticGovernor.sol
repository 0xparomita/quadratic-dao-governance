// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IQuadraticGovernance.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract QuadraticGovernor is IQuadraticGovernance {
    IERC20 public govToken;
    Proposal[] public proposals;
    
    // Mapping of User => ProposalID => Credits Spent
    mapping(address => mapping(uint256 => uint256)) public creditsSpent;

    constructor(address _govToken) {
        govToken = IERC20(_govToken);
    }

    function createProposal(string calldata _desc, uint256 _duration) external {
        proposals.push(Proposal({
            description: _desc,
            voteTally: 0,
            endTime: block.timestamp + _duration,
            executed: false
        }));
        emit ProposalCreated(proposals.length - 1, _desc);
    }

    /**
     * @notice Vote using Quadratic logic.
     * @param _proposalId The index of the proposal.
     * @param _numVotes The number of votes the user wants to ADD.
     * Cost is calculated as (CurrentVotes + AddedVotes)^2 - (CurrentVotes)^2
     */
    function vote(uint256 _proposalId, uint256 _numVotes) external {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp < p.endTime, "Voting ended");

        uint256 currentVotes = sqrt(creditsSpent[msg.sender][_proposalId]);
        uint256 newTotalVotes = currentVotes + _numVotes;
        uint256 newTotalCost = newTotalVotes * newTotalVotes;
        uint256 incrementalCost = newTotalCost - creditsSpent[msg.sender][_proposalId];

        // Ensure user has enough tokens (acting as voice credits)
        require(govToken.balanceOf(msg.sender) >= incrementalCost, "Insufficient credits");
        
        // Lock/Transfer tokens or simply check balance depending on DAO model
        // Here we assume a simple check against total balance for logic clarity
        creditsSpent[msg.sender][_proposalId] = newTotalCost;
        p.voteTally += _numVotes;

        emit Voted(msg.sender, _proposalId, _numVotes, incrementalCost);
    }

    // Babylonian method for square root
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}
