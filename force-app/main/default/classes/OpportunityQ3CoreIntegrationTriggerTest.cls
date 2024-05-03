@isTest
public class OpportunityQ3CoreIntegrationTriggerTest {
    @isTest
    static void testOpportunityQ3CoreIntegrationTrigger() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        Opportunity testOpp1 = new Opportunity(
            Name = 'Test Opportunity 1',
            StageName = 'Prospecting',
            Q3_Core_Sync__c = False,
            AccountId = testAccount.Id,
			Project_Name__c = 'Trial', 
            ProjectStatus__c = 'Active',
            Project_State__c = 'Active',
            Type = 'POC',
            Location__c = 'Gurugram',
            Payment_Term__c = '15 Days',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today()+1,
            Q3_Core_Response__c = 'trial',
            CloseDate = Date.today() + 1
        );
        insert testOpp1;
        test.startTest();
        testOpp1.StageName = 'Closed Won';
        update new List<Opportunity>{ testOpp1 };
        test.stopTest();
        if(testOpp1.Q3_Core_Sync__c == False){
            Q3CoreIntegrationHelper.makeHttpPostCallout(testOpp1.Id);
        }
    }
}