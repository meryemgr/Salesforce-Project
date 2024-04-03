@isTest
private class CalculateAmountTest {
    @isTest static void testNetAmmount() {
        // Création d'un compte
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        // Création d'un produit
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert pd1;

        // Création de l'entrée de catalogue de prix
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        insert pbe;

        // Create test orders related to the test account
        List<Order> testOrders = new List<Order>();
        for (Integer i = 0; i < 200; i++) {
            testOrders.add(new Order(AccountId = acc1.Id, EffectiveDate = Date.today(), Status = 'Draft', Pricebook2Id = Test.getStandardPricebookId()));
        }
        insert testOrders;

        // Create test order items related to the test orders
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order ord : testOrders) {
            orderItems.add(new OrderItem(OrderId = ord.Id, PricebookEntryId = pbe.Id, Quantity = 10, UnitPrice = 150));
        }
        insert orderItems;

        // Update test orders ShipmentCost__c
        for (Order ord : testOrders) {
            ord.ShipmentCost__c = 20;
        }
        update testOrders;

        // Retrieve the updated orders
        List<Order> updatedOrders = [SELECT Id, NetAmount__c FROM Order WHERE Id IN :testOrders];

        // Verifying that the net amount is correct for each order
        for (Order updatedOrder : updatedOrders) {
            System.assertEquals(1480, updatedOrder.NetAmount__c, 'NetAmount__c should be updated correctly');
        }
    }
    
    
}
