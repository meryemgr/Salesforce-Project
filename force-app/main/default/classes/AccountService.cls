public class AccountService {
    
    public static void updateAccountRevenue(List<Order> updatedOrders) {
        Set<Id> accountIds = new Set<Id>();
        
         // Filter updated orders with status "Activated" and retrieve associated account IDs
        for (Order updatedOrder : updatedOrders) {
            if (updatedOrder.Status == 'Activated') {
                accountIds.add(updatedOrder.AccountId);
            }
        }
        
        // Retrieve accounts associated with updated orders
        List<Account> accountsToUpdate = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN :accountIds];
        
        /// Iterate over retrieved accounts
        for (Account acc : accountsToUpdate) {
            acc.Chiffre_d_affaire__c = 0; /// Initialize revenue to 0
            
            // Iterate over updated orders to calculate revenue
            for (Order updatedOrder : updatedOrders) {
                if (updatedOrder.Status == 'Activated' && updatedOrder.TotalAmount != null) {
                    acc.Chiffre_d_affaire__c += updatedOrder.TotalAmount;
                }
            }
        }
        
        // Update modified accounts
        update accountsToUpdate;
    }
}
