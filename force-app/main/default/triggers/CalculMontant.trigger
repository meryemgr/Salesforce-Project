trigger CalculMontant on Order (before update) {
	
	//Order newOrder= trigger.new[0];
	for(integer i=0; i< trigger.new.size(); i++){
		Order newOrder= trigger.new[i];
	if (newOrder.TotalAmount != null && newOrder.ShipmentCost__c !=null) {
		
		newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
	}
}
}