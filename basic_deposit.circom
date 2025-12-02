// Basic Withdrawal Circuit - Educational Example
// Real Shades circuits verify complete private flows.

pragma circom 2.1.6;

include "./utils/poseidon.circom";
include "./utils/bitify.circom";

// Educational merkle tree inclusion proof
template MerkleInclusionProof(depth) {
    signal input leaf;
    signal input root;
    signal input pathIndices[depth];
    signal input siblings[depth];
    
    // Verify the merkle path
    var currentHash = leaf;
    
    for (var i = 0; i < depth; i++) {
        // This is simplified for education
        // Production uses proper hash function
        component hasher = Poseidon(2);
        
        // Depending on path index, order changes
        if (pathIndices[i] == 0) {
            // Left child
            hasher.inputs[0] <== currentHash;
            hasher.inputs[1] <== siblings[i];
        } else {
            // Right child
            hasher.inputs[0] <== siblings[i];
            hasher.inputs[1] <== currentHash;
        }
        
        currentHash = hasher.out;
    }
    
    // Final hash should match root
    root === currentHash;
}

// Basic withdrawal circuit
template BasicWithdraw() {
    // Public inputs (on-chain)
    signal input root;
    signal input nullifier;
    
    // Private inputs (user knows)
    signal input secret;
    signal input pathIndices[4];
    signal input siblings[4];
    signal input recipientHash; // Obfuscated recipient
    
    // Outputs (verified in proof)
    signal output commitment;
    signal output nullifierHash;
    
    // 1. Verify secret creates correct nullifier
    component nullifierHasher = Poseidon(2);
    nullifierHasher.inputs[0] <== secret;
    nullifierHasher.inputs[1] <== 1; // Fixed salt for education
    
    // Nullifier must match public input
    nullifier === nullifierHasher.out;
    nullifierHash <== nullifierHasher.out;
    
    // 2. Recreate commitment from secret
    component commitmentHasher = Poseidon(3);
    commitmentHasher.inputs[0] <== secret;
    commitmentHasher.inputs[1] <== 100; // Fixed amount for education
    commitmentHasher.inputs[2] <== 123; // Fixed randomness
    
    commitment <== commitmentHasher.out;
    
    // 3. Verify merkle inclusion
    component merkleProof = MerkleInclusionProof(4);
    merkleProof.leaf <== commitment;
    merkleProof.root <== root;
    
    for (var i = 0; i < 4; i++) {
        merkleProof.pathIndices[i] <== pathIndices[i];
        merkleProof.siblings[i] <== siblings[i];
    }
  ts
    secret != 0;
    
    // Recipient hash must be non-zero (educational)
    recipientHash != 0;
}

component main { public [ root, nullifier ] } = BasicWithdraw();
