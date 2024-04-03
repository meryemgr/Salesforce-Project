@isTest
private class AccountServiceTest {
   
        @isTest static void testChiffreAffaire() {
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
    
            // Update test orders status
            for (Order ord : testOrders) {
                ord.Status = 'Activated';
            }
            update testOrders;
    
        
        // Récupération du compte mis à jour
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];

        // Vérification que le chiffre d'affaires est correct
        System.assertEquals(300000, updatedAccount.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should be updated correctly');
    }
    
    

}
