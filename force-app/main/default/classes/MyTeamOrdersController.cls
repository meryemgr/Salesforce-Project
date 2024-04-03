public with sharing class MyTeamOrdersController {
    public Decimal sumOrders {
        get {
            // Exécuter une requête SOQL pour obtenir la somme des montants totaux des commandes avec le statut "Activated"
            AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Activated'];
            
            // Récupérer le total de la somme et le retourner
            if (groupedResults.get('total') != null) {
                return (Decimal) groupedResults.get('total');
            } else {
                return 0;
            }
        }
        set;
    }
}
