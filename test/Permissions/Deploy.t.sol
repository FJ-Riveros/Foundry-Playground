// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import { PermissionsSetup } from "./PermissionsSetup.sol";

contract TestPermissions is PermissionsSetup {
  function test_ApprovalForAll() public {
    vm.startPrank(USER);
    nftContract1.setApprovalForAll(address(transferContract), true);
    assertEq(
      nftContract1.isApprovedForAll(USER, address(transferContract)),
      true
    );
    nftContract2.setApprovalForAll(address(transferContract), true);
    assertEq(
      nftContract2.isApprovedForAll(USER, address(transferContract)),
      true
    );
    vm.stopPrank();
  }

  function test_TokensReceived() public {
    assertEq(tokenContract1.balanceOf(USER), TOKEN_MINT_SIZE);
    assertEq(tokenContract2.balanceOf(USER), TOKEN_MINT_SIZE);
  }

  function test_UserApprovesTransferForERC20() public {
    vm.startPrank(USER);
    tokenContract1.approve(address(transferContract), MAX_UINT);
    assertEq(
      tokenContract1.allowance(USER, address(transferContract)),
      MAX_UINT
    );
    tokenContract2.approve(address(transferContract), MAX_UINT);
    assertEq(
      tokenContract2.allowance(USER, address(transferContract)),
      MAX_UINT
    );
    vm.stopPrank();
  }
}
