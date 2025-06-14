pragma circom 2.0.0;


template Hash() {
    signal input x;
    signal input hash;

    component poseidon = Poseidon(1);
    poseidon.inputs[0] <== x;
    
    poseidon.out === hash;
    
}