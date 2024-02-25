-include .env

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

build :; forge build

test :; forge test

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

NETWORK_ARGS := --rpc-url http://localhost:8545 --private-key $(DEFAULT_ANVIL_KEY) --broadcast

deploy:
	forge script script/DeployFundMe.s.sol:DeployFundMe $(NETWORK_ARGS)

fund:
	forge script script/Interactions.s.sol:FundFundMe $(NETWORK_ARGS)

withdraw:
	forge script script/Interactions.s.sol:WithdrawFundMe $(NETWORK_ARGS)