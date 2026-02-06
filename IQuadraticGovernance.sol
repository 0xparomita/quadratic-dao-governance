// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IQuadraticGovernance {
    struct Proposal {
        string description;
        uint256 voteTally;
        uint256 endTime;
        bool executed;
    }

    event ProposalCreated(uint256 indexed id, string description);
    event Voted(address indexed voter, uint256 indexed proposalId, uint256 votes, uint256 cost);
}
