trigger UpdateAccountCA on Order (after update) {
	
    set<Id> setAccountIds = new set<Id>();
    Order order= trigger.new[0];
    List<Account> Listacc = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id =:order.AccountId ];

    for(integer j=0; j < Listacc.size(); j++){
        Account myAccount = Listacc[j];
        myAccount.Chiffre_d_affaire__c = 0;
    for(integer i=0; i< trigger.new.size(); i++){
        Order newOrder= trigger.new[i];
        
        if (newOrder.TotalAmount != null && myAccount.Chiffre_d_affaire__c !=null ) {
        myAccount.Chiffre_d_affaire__c = myAccount.Chiffre_d_affaire__c + newOrder.TotalAmount;
    }
    }
}
    update Listacc;
}


