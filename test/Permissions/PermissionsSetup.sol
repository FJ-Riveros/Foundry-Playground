// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Vault.sol";
import "src/NFT.sol";
import "src/Fungible.sol";
import "src/Transfer.sol";
import { StdUtils } from "forge-std/StdUtils.sol";

abstract contract PermissionsSetup is StdUtils, Test {
  NFT nftContract1;
  NFT nftContract2;
  Fungible tokenContract1;
  Fungible tokenContract2;
  Transfer transferContract;
  Vault vaultContract;
  address recipientAddr;
  address constant TRANSFER_SIGNER = address(0x1);
  address constant SERVER_SIGNER = address(0x2);
  address constant FEE_CONTROLLER = address(0x3);
  address constant USER = address(0x4);
  address constant USER2 = address(0x5);
  address constant USER3 = address(0x6);
  uint256 constant TOKEN_MINT_SIZE = 1000 * 10**18;
  uint256 constant MAX_UINT = type(uint256).max;
  uint8 EXACT_FEE = 100;
  uint8 OVER_FEE = 101;
  uint8 UNDER_FEE = 99;

  function setUp() public {
    address transferAddress = computeCreateAddress(
      msg.sender,
      vm.getNonce(msg.sender)
    );
    address vaultAddress = computeCreateAddress(
      msg.sender,
      vm.getNonce(msg.sender) + 1
    );

    transferContract = new Transfer(vaultAddress, TRANSFER_SIGNER);
    vaultContract = new Vault(
      transferAddress,
      SERVER_SIGNER,
      payable(FEE_CONTROLLER)
    );
    vm.startPrank(USER);
    nftContract1 = new NFT();
    nftContract2 = new NFT();
    tokenContract1 = new Fungible();
    tokenContract2 = new Fungible();
    nftContract1.mint(USER);
    nftContract2.mint(USER);
    nftContract1.mint(USER);
    nftContract2.mint(USER);
    nftContract1.mint(USER);
    nftContract2.mint(USER);
    nftContract1.mint(USER);
    nftContract2.mint(USER);
    vm.stopPrank();
  }
}
