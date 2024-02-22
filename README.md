# Foundry Fund Me

This is a section of the Cyfrin Solidity Course.

- [Foundry Fund Me](#foundry-fund-me)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Quickstart](#quickstart)
- [Usage](#usage)
  - [Testing](#testing)
    - [Test Coverage](#test-coverage)
- [Deployment to a testnet or mainnet](#deployment-to-a-testnet-or-mainnet)
  - [Scripts](#scripts)
  - [Makefile](#Makefile for scripts)
    - [Withdraw](#withdraw)
  - [Estimate gas](#estimate-gas)
- [Formatting](#formatting)
- [Retrieve real-world data](#retrieve-real-world-data)
- [Clear hard-coded addresses to make contracts modular](#clear-hard-coded-addresses-to-make-contracts-modular)
- [Other information](#other-information)


# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`


## Quickstart

```
git clone https://github.com/denisgulev/foundry-fund-me-f23
cd foundry-fund-me-f23
forge build
```

# Usage

## Deploy:

```
forge script script/DeployFundMe.s.sol
```

## Testing

To test the code, you can run either one of the following commands:

```
forge test
```

or 

```
forge test --match-test testFunctionName
```

or

```
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage

```
forge coverage
```


# Deployment to a testnet or mainnet

1. Setup environment variables

You'll want to set your `SEPOLIA_RPC_URL` and `PRIVATE_KEY` as environment variables. You can add them to a `.env` file, similar to what you see in `.env.example`.

- `PRIVATE_KEY`: The private key of your account (like from [metamask](https://metamask.io/)). **NOTE:** FOR DEVELOPMENT, PLEASE USE A KEY THAT DOESN'T HAVE ANY REAL FUNDS ASSOCIATED WITH IT.
  - You can [learn how to export it here](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key).
- `SEPOLIA_RPC_URL`: This is url of the sepolia testnet node you're working with. You can get setup with one for free from [Alchemy](https://alchemy.com/?a=673c802981)

Optionally, add your `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/).

1. Get testnet ETH

Head over to [faucets.chain.link](https://faucets.chain.link/) and get some testnet ETH. You should see the ETH show up in your metamask.

3. Deploy

```
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## Scripts

After deploying to a testnet or local net, you can run the scripts. 

Using cast deployed locally example: 

```
cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key <PRIVATE_KEY>
```

or
```
forge script script/Interactions.s.sol --rpc-url sepolia  --private-key $PRIVATE_KEY  --broadcast
```

### Makefile for scripts

Use Makefile to create shortcuts for the long commands used in the previous paragraphs.

### Withdraw

```
cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()" --private-key <PRIVATE_KEY>
```

## Estimate gas

You can estimate how much gas things cost by running:

```
forge snapshot
```

And you'll see an output file called `.gas-snapshot`


# Formatting


To run code formatting:
```
forge fmt
```


# Retrieve real-world data

1. install the package locally in the 'lib' folder, through 
```
forge install <package>@<package-version> --no-commit
```
2. add a remapping in the .toml file to link @chainlink/contracts to the installed package


# Clear hard-coded addresses to make contracts modular

1. make contract's constructor receive an address argument and create a private variable
2. deploy the contract passing the address of the chain we want to deploy to
3. in the deploy script, make the "run" function returns a contract, so that we can use 
    the deploy script in our tests
4. 'HelperConfig.s.sol' allows us to use an address related to the chain we are running on (ex. we can run test with deployment on local anvil chain)


# Other information

- Chisel -> allows to write solidity statements and executes them in the terminal

- Storage -> Contract's variables are stored one by one in "Storage", except:
    - constants
    - immutables
    - function's variables, which persists in a separate memory for the duration of the function

    We can inspect the Storage of a contract:
    ```
        forge inspect <contract-name> storageLayout
    ```

    To inspect the storage of a LIVE contract:
    ```
        cast storage <live-contract-name> <index-to-inspect>
    ```

    ** Reading and writing from Storage, costs a lot of gas


###### CURRENT time on video

https://youtu.be/sas02qSFZ74?list=PL4Rj_WH6yLgWe7TxankiqkrkVKXIwOP42&t=7360