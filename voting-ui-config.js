export const QV_CONFIG = {
  contractAddress: "0x...",
  tokenDecimals: 18,
  calculateCost: (votes) => votes ** 2,
  calculateVotes: (credits) => Math.sqrt(credits)
};
