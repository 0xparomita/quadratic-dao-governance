# Quadratic DAO Governance

This repository implements a **Quadratic Voting (QV)** system for Decentralized Autonomous Organizations. In this model, voters use "Voice Credits" to cast votes, where the cost in credits is the square of the votes delivered.

## Features
* **Voice Credit System:** Users receive credits based on their token holdings or reputation.
* **Quadratic Cost Logic:** To cast $n$ votes, a user must spend $n^2$ credits.
* **On-Chain Proposal Lifecycle:** Full flow from submission to weighted tallying and execution.
* **Anti-Whale Mechanism:** Reduces the linear influence of large capital holders.



## Technical Overview
The core logic resides in `QuadraticGovernor.sol`. It calculates the square root or requires the user to pass the squared value and verifies it against their credit balance to maintain gas efficiency.
