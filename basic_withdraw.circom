// Basic Withdrawal Circuit - Educational Example
// NOT for production use - demonstrates concepts only

pragma circom 2.1.6;

include "node_modules/circomlib/circuits/poseidon.circom";
include "node_modules/circomlib/circuits/bitify.circom";

template MerkleTreeInclusion(depth) {
    // Public inputs
    signal input root;
    signal input nullifierHash;
    
    // Private inputs
    signal input secret;
    signal input pathIndices[depth];
    signal input pathElements[depth];
    signal input leafIndex;
    
    // Output
    signal output commitment;
    
    // Hash the secret to create nullifier
    component nullifierHasher = Poseidon(1);
    nullifierHasher.inputs[0] <== secret;
    nullifierHash === nullifierHasher.out;
    
    // Hash the secret with fixed value to create commitment
    component commitmentHasher = Poseidon(2);
    commitmentHasher.inputs[0] <== secret;
    commitmentHasher.inputs[1] <== 1; // Fixed deposit identifier
    commitment <== commitmentHasher.out;
    
    // Verify merkle path (simplified for education)
    var computedPath = commitment;
    for (var i = 0; i < depth; i++) {
        // This is simplified - real circuit would have proper hash
        computedPath = pathIndices[i] == 0 
            ? computedPath + pathElements[i] 
            : pathElements[i] + computedPath;
    }
    
    // Final check (simplified)
    root === computedPath;
}

// Main circuit - depth 4 for education (production would use 20+)
template BasicWithdraw() {
    signal input root;
    signal input nullifierHash;
    
    signal input secret;
    signal input pathIndices[4];
    signal input pathElements[4];
    signal input leafIndex;
    
    signal output commitment;
    
    component tree = MerkleTreeInclusion(4);
    
    tree.root <== root;
    tree.nullifierHash <== nullifierHash;
    tree.secret <== secret;
    
    for (var i = 0; i < 4; i++) {
        tree.pathIndices[i] <== pathIndices[i];
        tree.pathElements[i] <== pathElements[i];
    }
    
    tree.leafIndex <== leafIndex;
    commitment <== tree.commitment;
}

component main = BasicWithdraw();
