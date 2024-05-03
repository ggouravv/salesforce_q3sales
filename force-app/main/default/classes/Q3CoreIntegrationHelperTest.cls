@isTest
public class Q3CoreIntegrationHelperTest {
    private class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock HTTP response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"status": "success"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testMakeHttpPostCalloutSuccess() {
        // Created a test Account
        Account newAccount = new Account(Name = 'Test Account');
        insert newAccount;

        // Created a test Opportunity related to the test Account
        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opportunity 111',
            StageName = 'Closed Won',
            Q3_Core_Sync__c = False,
            AccountId = newAccount.Id,
            Project_Name__c = 'Trial', 
            ProjectStatus__c = 'Active',
            Project_State__c = 'Active',
            Type = 'POC',
            Location__c = 'Gurugram',
            Payment_Term__c = '15 Days',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today() + 1,
            Q3_Core_Response__c = 'trial',
            CloseDate = Date.today() + 1
        );
        insert testOpportunity;

        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        Q3CoreIntegrationHelper.makeHttpPostCallout(testOpportunity.Id);
        Test.stopTest();

        Opportunity updatedOpportunity = [SELECT Id, Q3_Core_Sync__c FROM Opportunity WHERE Id = :testOpportunity.Id LIMIT 1];
        System.assertEquals(false, updatedOpportunity.Q3_Core_Sync__c);
    }  

}