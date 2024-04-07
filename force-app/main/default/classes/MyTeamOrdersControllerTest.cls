@isTest
private class MyTeamOrdersControllerTest {
    @isTest
    static void testSumOrders() {
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

        // Create draft orders
        List<Order> draftOrders = new List<Order>();
        for (Integer j = 0; j < 200; j++) { // Changed the loop to create 200 draft orders
            draftOrders.add(new Order(AccountId = testAccount.Id, EffectiveDate = Date.today(), Status = 'Draft', Pricebook2Id = Test.getStandardPricebookId()));
        }
        insert draftOrders;

        // Create test order items related to the draft orders
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order ord : draftOrders) {
            orderItems.add(new OrderItem(OrderId = ord.Id, PricebookEntryId = pbe.Id, Quantity = 10, UnitPrice = 150));
        }
        insert orderItems;

        // Activate the draft orders
        for (Order ord : draftOrders) {
            ord.Status = 'Activated';
        }
        update draftOrders;

        // Create an instance of the controller
        MyTeamOrdersController controller = new MyTeamOrdersController();

        // Call the SumOrders property to get the total of activated order amounts
        Decimal sum = controller.sumOrders;

        // Verify that the total is correct
        System.assertEquals(200 * 10 * 150, sum, 'Total of activated orders should be correct');
    }
}
