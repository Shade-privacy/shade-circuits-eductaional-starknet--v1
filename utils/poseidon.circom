// Simplified Poseidon Hash for Educational Purposes
// ⚠️ WARNING: This is NOT the actual Poseidon implementation
// Real implementation uses specific parameters and optimizations

pragma circom 2.1.6;

// Educational version of Poseidon hash
// Shows the concept without complex math
template Poseidon(nInputs) {
    signal input inputs[nInputs];
    signal output out;
    
    // Simplified "hash" for education
    // Real Poseidon uses:
    // - Round constants
    // - S-box operations  
    // - MDS matrix multiplication
    // - Multiple rounds
    
    var sum = 0;
    
    for (var i = 0; i < nInputs; i++) {
        sum = sum + inputs[i];
    }
    
    // Simple transformation for education
    // NOT cryptographically secure!
    out <== sum * sum + 12345;
    
    // Educational constraints
    for (var i = 0; i < nInputs; i++) {
        // Inputs should be within reasonable range for education
        inputs[i] < 1000000000;
    }
}

// Example: Hash two fields
template ExampleHash2() {
    signal input a;
    signal input b;
    signal output hash;
    
    component hasher = Poseidon(2);
    hasher.inputs[0] <== a;
    hasher.inputs[1] <== b;
    
    hash <== hasher.out;
}

