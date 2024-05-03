trigger OpportunityQ3CoreIntegrationTrigger on Opportunity (after update) {
    for(Opportunity opp :Trigger.New){
        if(opp.StageName == 'Closed Won' && !opp.Q3_Core_Sync__c){
                Q3CoreIntegrationHelper.makeHttpPostCallout(opp.Id);
        }
    }
}