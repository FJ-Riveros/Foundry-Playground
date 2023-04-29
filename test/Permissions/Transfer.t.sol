// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import { PermissionsSetup } from "./PermissionsSetup.sol";

contract TestTransfer is PermissionsSetup {
  function test_cannotTransferIfNotWhitelisted() public {
    vm.expectRevert();
    vm.prank(TRANSFER_SIGNER);
    transferContract.transferERC20(USER, address(tokenContract1), 100);
  }

  function test_cannotSetTransferEOAIfNotEOASetter() public {
    vm.prank(SERVER_SIGNER);
    vm.expectRevert();
    transferContract.setTransferEOA(SERVER_SIGNER, true);
    vm.prank(TRANSFER_SIGNER);
    transferContract.setTransferEOA(SERVER_SIGNER, true);
  }

  function test_cannotTransferIfNoLongerTransferEOA() public {
    // approve the transfer contract to move the nfts
    vm.prank(USER);
    nftContract1.setApprovalForAll(address(transferContract), true);
    assertEq(
      nftContract1.isApprovedForAll(USER, address(transferContract)),
      true
    );

    // whitelist the USER2 to transfer
    vm.prank(TRANSFER_SIGNER);
    transferContract.setTransferEOA(USER2, true);
    vm.prank(USER2);

    // transfer
    transferContract.transferERC721(USER, address(nftContract1), 1, 100);
    vm.prank(TRANSFER_SIGNER);

    // revoke the whitelist
    transferContract.setTransferEOA(USER2, false);

    // revert because the USER2 is no longer allowed to transfer
    vm.prank(USER2);
    vm.expectRevert();
    transferContract.transferERC721(USER, address(nftContract1), 2, 100);
  }
}
