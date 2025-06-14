#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <password>"
    exit 1
fi

PASSWORD=$1

# Create input.json
#EDIT to include hash
echo "{ \"x\": $PASSWORD }" > input.json

# Compile the circuit
echo "Compiling circuit..."
circom main.circom --r1cs --wasm --sym --c

# Generate the witness
echo "Generating witness..."
node main_js/generate_witness.js main_js/main.wasm input.json witness.wtns

# Setup trusted setup
echo "Running trusted setup..."
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
snarkjs groth16 setup main.r1cs pot12_final.ptau main_0000.zkey
snarkjs zkey contribute main_0000.zkey main_0001.zkey --name="1st Contributor" -v
snarkjs zkey export verificationkey main_0001.zkey verification_key.json

# Generate the proof
echo "Generating zk-SNARK proof..."
snarkjs groth16 prove main_0001.zkey witness.wtns proof.json public.json

# Verify the proof
echo "Verifying proof..."
snarkjs groth16 verify verification_key.json public.json proof.json