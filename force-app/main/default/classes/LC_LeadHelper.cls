public with sharing class LC_LeadHelper {
	@AuraEnabled
    public static Company__c getCompanyData(id companyID){
        Company__c Companydata = [select Name,Postal_Code__c, City__c, Street__c, State_Province__c, Country__c,Industry__c, No_of_Employees__c, HQ_Phone__c, Website__c from Company__c where id=:companyID]; 
        return Companydata;
    }


    
    /*@AuraEnabled
    public static void createLead(Lead leadData) {
        // Perform lead creation logic here
        try {
            update leadData;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }*/
    

}