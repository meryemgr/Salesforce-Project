global class UpdateAccounts implements Database.Batchable<sObject>{
   
    global Database.QueryLocator start(Database.BatchableContext info){
        // Requêter seulement les comptes qui ont au moins une commande avec le statut 'Ordered'
        return Database.getQueryLocator([
            SELECT Id
            FROM Account
            WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Activated')
        ]);
    }

    global void execute(Database.BatchableContext info, List<Account> scope){      
        List<Order> listOrders = [SELECT Id, TotalAmount, AccountId FROM Order];
       
        for(Integer i = 0; i < scope.size(); i++){
            Account myAccount = scope[i];
            myAccount.Chiffre_d_affaire__c = 0;
           
            for(Integer j = 0; j < listOrders.size(); j++){
                if(listOrders[j].AccountId == myAccount.Id){
                    myAccount.Chiffre_d_affaire__c += listOrders[j].TotalAmount;
                }                  
            }
        }
       
        update scope;
    }    
   
    global void finish(Database.BatchableContext info){    
        // Optional: Implement any finish logic if needed
    }
}