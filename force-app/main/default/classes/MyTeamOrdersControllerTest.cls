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
        // Créer des commandes avec différents statuts pour simuler des données de test
        
        List<Order> testOrders = new List<Order>();
        for (Integer i = 0; i < 150; i++) {
            testOrders.add(new Order(AccountId = testAccount.Id, EffectiveDate = Date.today(), Status = 'Activated', Pricebook2Id = Test.getStandardPricebookId()));
        }
        for (Integer j = 0; j < 50; j++) {
            
            testOrders.add(new Order(AccountId = testAccount.Id, EffectiveDate = Date.today(), Status = 'Draft', Pricebook2Id = Test.getStandardPricebookId()));
        }
        insert testOrders;

    
     

     // Create test order items related to the test orders
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order ord : testOrders) {
            orderItems.add(new OrderItem(OrderId = ord.Id, PricebookEntryId = pbe.Id, Quantity = 10, UnitPrice = 150));
        }
        insert orderItems;



        // Créer une instance du contrôleur
        MyTeamOrdersController controller = new MyTeamOrdersController();

        // Appeler la propriété SumOrders pour obtenir le total des montants des commandes activées
        Decimal sum = controller.SumOrders;

        // Vérifier que le total est correct
        System.assertEquals(600, sum, 'Total of activated orders should be 600');
    }
}
