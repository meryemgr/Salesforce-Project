// Controller class to handle the logic for the Visualforce page MyTeamOrdersPage
public with sharing class MyTeamOrdersController {
   // Property to store the sum of orders
    public Decimal sumOrders {
        get {
            // Execute a SOQL query to retrieve the sum of total amounts of orders with the status "Activated"
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Activated'];
            
            // Retrieve the total sum and return it
            if (groupedResults.get('total') != null) {
                return (Decimal) groupedResults.get('total');
            } else {
                return 0;
            }
        }
        set;
    }
}
