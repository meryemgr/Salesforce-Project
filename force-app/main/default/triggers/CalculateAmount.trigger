trigger CalculateAmount on Order (before update) {
	
	for(Integer i = 0; i < Trigger.new.size(); i++) {
		Order newOrder = Trigger.new[i];
		if (newOrder.TotalAmount != null && newOrder.ShipmentCost__c != null) {
			newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
		}
	}
}
