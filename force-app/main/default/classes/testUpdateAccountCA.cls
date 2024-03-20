@isTest
private class testUpdateAccountCA {
   
    @isTest static void testCA() {
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;
 
        // Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        Order o1 = new Order(AccountId = acc1.Id,Status='Draft', EffectiveDate=Date.today());
         o1.Pricebook2Id = Test.getStandardPricebookId();
        insert o1;
		
        OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
        insert oi1;
        OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
        insert oi2;

     	update o1;
        // Retrieve the updated Account
        Account updatedAccount = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc1.Id];

        // Add assertions to verify the update
        System.assertEquals(21500, updatedAccount.Chiffre_d_affaire__c, 'Chiffre_d_affaire__c should be updated correctly');
       
        
        
   
}
    
    
    @isTest static void testNA() {
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;

        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        Insert pd1;
 
        // Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;

        Order o1 = new Order(AccountId = acc1.Id,Status='Draft', EffectiveDate=Date.today(),ShipmentCost__c = 50);
         o1.Pricebook2Id = Test.getStandardPricebookId();
        insert o1;
		
        OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
        insert oi1;
        OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
        insert oi2;

      // Mettre à jour la commande pour déclencher CalculMontant
        o1.ShipmentCost__c = 20;
      update o1;
        // Vérifier que le champ NetAmount__c est correctement mis à jour
        Order updatedOrder = [SELECT Id, NetAmount__c FROM Order WHERE Id = :o1.Id LIMIT 1];
        System.assertEquals(21480, updatedOrder.NetAmount__c, 'NetAmount__c should be updated correctly');
        
        
        
        
   
}
}