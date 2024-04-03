trigger UpdateAccountCA on Order (after update) {
    // Call the service method to update the revenue of accounts
    AccountService.updateAccountRevenue(Trigger.new);
}
