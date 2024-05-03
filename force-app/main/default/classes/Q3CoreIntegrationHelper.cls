public class Q3CoreIntegrationHelper {
    @future(callout= true)
    public static void makeHttpPostCallout(Id oppID) {
        //system.debug('makeHttpPostCallout Method calling');
        Opportunity opp = [Select Id,AccountId,Project_Name__c,ProjectStatus__c,Project_State__c,Type,Location__c,Start_Date__c,End_Date__c,Payment_Term__c from Opportunity where Id = :oppID Limit 1];
        
        // Replace these placeholders with your actual API endpoint and app token ID
        String endpointUrl = 'https://2f9e-2405-201-6017-8-8123-241b-d2ac-acff.ngrok-free.app/api/create-project';
        String appTokenId = 'ASDFG123654PLWPD';
        
        // Construct the JSON data
        String jsonData = getJsonDataFromSalesforceObjects(opp);
        system.debug(jsonData);
        try{
            //system.debug('try calling');
            // Set up the HTTP request
            
            Http httpCon = new Http(); 
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpointUrl);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('app-token-id', appTokenId);
            request.setBody(jsonData);
            HttpResponse response = httpCon.send(request);
            Id OpportunityID = opp.Id;
            Opportunity Opportunityobj = new Opportunity();
            Opportunityobj.Id = OpportunityID;
            
            // Get the body of the response
            String responseBody = response.getBody();
            //system.debug(responseBody);
            
            // Deserialize the JSON string into a Map<String, Object>
            Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(responseBody);
            
            // Create a new Map<String, String> to store the final result
            Map<String, String> resultMap = new Map<String, String>();
            
            // Convert values from Object to String and populate the resultMap
            for (String key : jsonMap.keySet()) {
                String value = String.valueOf(jsonMap.get(key));
                resultMap.put(key, value);
            }
            
            // Now, resultMap contains the key-value pairs from the JSON response
            //System.debug(resultMap);
            string responseMessage = resultMap.get('responseMessage');	
            string responseCode = resultMap.get('responseCode');
            
            // Handle the response
            if (responseCode == '1000') {
                System.debug('HTTP POST successful. Response: ' + response.getBody());
                //Update Sync sucess status            
                Opportunityobj.Q3_Core_Sync__c = true;
	            string responseId = resultMap.get('Id');
                Opportunityobj.Q3_Core_Response__c = 'Q3 Core Project ID-'+responseId+'. '+responseMessage;
            } else {
                //Update Sync Failed status
                Opportunityobj.Q3_Core_Response__c = 'Failed -'+responseMessage;
            }
            update Opportunityobj;
            
            
        }
        catch(Exception e) {
            system.debug('catch calling');
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());    
        }
        system.debug('End');
    }
    
    public static String getJsonDataFromSalesforceObjects(Opportunity opp) {
        Map<String, String> requestData = new Map<String,String>();
        String AccountName = [Select Name from Account where Id = :opp.AccountId Limit 1].Name;
        requestData.put('clientName', AccountName);
        requestData.put('projectName', opp.Project_Name__c) ;
        requestData.put('projectStatus', opp.ProjectStatus__c) ;
        requestData.put('projectState', opp.Project_State__c) ;
        requestData.put('type', opp.Type) ;
        requestData.put('location', opp.Location__c) ;
        requestData.put('startDate', String.valueOf(opp.Start_Date__c));
        requestData.put('endDate', String.valueOf(opp.End_Date__c));
        requestData.put('paymentTerm', opp.Payment_Term__c) ;
        return JSON.serialize(requestData);
    }
    
}