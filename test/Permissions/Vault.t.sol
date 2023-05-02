// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import { PermissionsSetup } from "./PermissionsSetup.sol";

contract TestVaultPermissions is PermissionsSetup {
  function test_cannotWithdrawERC721WithoutAllowance() public {
    assertEq(vaultContract.viewRecipientAddress(USER), address(0x0));
    vm.expectRevert();
    vaultContract.withdrawERC721(USER, address(nftContract1), 1);
  }

  function test_cannotWithdrawERC20WithoutAllowance() public {
    assertEq(vaultContract.viewRecipientAddress(USER), address(0x0));
    vm.expectRevert();
    vaultContract.withdrawERC20(USER, address(tokenContract1));
  }

  function test_canSetupRecipientAddress() public {
    vm.prank(USER);
    vaultContract.setupRecipientAddress(USER2);
    assertEq(vaultContract.viewRecipientAddress(USER), USER2);
  }

  function test_cannotSetupRecipiendAddressTwice() public {
    vm.expectRevert();
    vm.prank(USER);
    vaultContract.setupRecipientAddress(address(0));
    vaultContract.setupRecipientAddress(USER3);
    vaultContract.viewRecipientAddress(USER);
  }
}
