public without sharing class DefaultLeadHelper {
    public static Id checkForCompany(Lead Leaddata) {
        Id companyID;
        try{
            Company__c[] Companyrecord = [select Name,Id from Company__c where Name=:Leaddata.Company limit 1];
            if(Companyrecord.size() > 0){
                companyID = Companyrecord[0].Id;
            }else{
                Company__c companyobj   = new Company__c();
                companyobj.Name      = Leaddata.Company;
                //companyobj.HQ_Phone__c  = Leaddata.MobilePhone;
                insert companyobj;
                companyID = companyobj.Id;
            }
        }
        catch (Exception e) {
        }
        return companyID;
    }
    public static boolean checkForEmail(string emailID,id leadID) {
        boolean emailvalidate;
        try{
            lead[] emailArr = [select Id from Lead where Email=:emailID and id !=:leadID];
            if(emailArr.size() > 0){
                emailvalidate = true;
            }
        }
        catch (Exception e) {
        }
        return emailvalidate;
    }
    public static boolean checkForEmailLinkedIn(string emailID,string LinkedIn,id leadID) {
        boolean emaillinkedinvalidate;
        try{
            lead[] emailArr = [select Id from Lead where Email=:emailID and LinkedIn__c=:LinkedIn and id !=:leadID];
            if(emailArr.size() > 0){
                emaillinkedinvalidate = true;
            }else{
                emaillinkedinvalidate = false; 
            }
        }
        catch (Exception e) {
        }
        return emaillinkedinvalidate;
    }
    
    public static boolean checkForEmailNewRecord(string emailID) {
        boolean emailvalidate;
        try{
            lead[] emailArr = [select Id from Lead where Email=:emailID];
            if(emailArr.size() > 0){
                emailvalidate = true;
            }
        }
        catch (Exception e) {
        }
        return emailvalidate;
    }
    public static boolean checkForEmailLinkedInNewRecord(string emailID,string LinkedIn) {
        boolean emaillinkedinvalidate;
        try{
            lead[] emailArr = [select Id from Lead where Email=:emailID and LinkedIn__c=:LinkedIn];
            if(emailArr.size() > 0){
                emaillinkedinvalidate = true;
            }else{
                emaillinkedinvalidate = false; 
            }
        }
        catch (Exception e) {
        }
        return emaillinkedinvalidate;
    }
}