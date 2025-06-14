# ZKP-auth
Zero Knowledge proof online authentication system, built using Circom

## TODOs

DONE: Write a basic circuit: prove knowledge of a preimage x such that H(x) == y

TODO: Store user public credentials.

TODO: Test local login with CLI proof and verifier

## About ZKP

ZPK stands for Zero Knowledge proofs, This means you never send your password or any form of the password through and use only proof that you know it.

## Creating and verifying the circuit

We will use a bash script to start off and compile with input of the given password

The script will first need to compile the program

'''bash
circom main.circom --r1cs --wasm --sym --c
'''

Next we will need to create the prover, creating a json file called 