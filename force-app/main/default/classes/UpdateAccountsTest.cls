@isTest
private class UpdateAccountsTest {

    @isTest
    static void testUpdateAccountsBatch() {
        // Create test product
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;

        // Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 100,
            IsActive = true
        );
        Insert pbe;

        // Create a test account
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Create test orders related to the test account
        List<Order> testOrders = new List<Order>();
        for (Integer i = 0; i < 200; i++) {
            testOrders.add(new Order(AccountId = testAccount.Id, EffectiveDate = Date.today(), Status = 'Draft', Pricebook2Id = Test.getStandardPricebookId()));
        }
        insert testOrders;

        // Create test order items related to the test orders
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order ord : testOrders) {
            orderItems.add(new OrderItem(OrderId = ord.Id, PricebookEntryId = pbe.Id, Quantity = 10, UnitPrice = 150));
        }
        insert orderItems;

        // Update test orders status
        for (Order ord : testOrders) {
            ord.Status = 'Activated';
        }
        update testOrders;

        // Execute the batch
        Test.startTest();
        UpdateAccounts batchClassInstance = new UpdateAccounts();
        Database.executeBatch(batchClassInstance);
        Test.stopTest();

        // Verify that the account's revenue has been updated
        testAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(300000, testAccount.Chiffre_d_affaire__c);
    }
}