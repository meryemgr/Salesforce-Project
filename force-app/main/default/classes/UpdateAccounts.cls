global class UpdateAccounts implements Database.Batchable<sObject>{
   
        // Start method to initialize batch processing
    global Database.QueryLocator start(Database.BatchableContext info){
        // Query to select only the accounts that have at least one order with status 'Activated'
        return Database.getQueryLocator([
            SELECT Id
            FROM Account
            WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')
        ]);
    }

    // Execute method to perform batch processing
    global void execute(Database.BatchableContext info, List<Account> scope){      
        // Retrieving all orders
        List<Order> listOrders = [SELECT Id, TotalAmount, AccountId FROM Order];
       
        // Iterating over each account in the current batch
        for(Integer i = 0; i < scope.size(); i++){
            Account myAccount = scope[i];
            myAccount.Chiffre_d_affaire__c = 0; // Initializing the revenue of the account to 0
           
                        // Iterating over all orders to find those associated with this account
            for(Integer j = 0; j < listOrders.size(); j++){
                if(listOrders[j].AccountId == myAccount.Id){
                    // Adding the total amount of the order to the account's revenue
                    myAccount.Chiffre_d_affaire__c += listOrders[j].TotalAmount;
                }                  
            }
        }
       
        // Updating the modified accounts in the current batch
        update scope;
    }    
   
    // Finish method to finalize batch processing
    global void finish(Database.BatchableContext info){    
        
    }
}
