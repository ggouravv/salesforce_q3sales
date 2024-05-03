@IsTest
public class Testcls_LeadHelper {
    /* @IsTest
public static void TestcheckForCompany(){
Test.startTest();        
id cmpid = 'a005j00000QF2jAAAT';
lead leadobj = [select id,name,Company from lead where id='00Q5j00000SFiDSEA1'];
Id getcmpid = DefaultLeadHelper.checkForCompany(leadobj);
Test.stopTest();
Assert.areEqual(
cmpid,
getcmpid,
'Tested successfully'
);
}*/
    @IsTest
    public static void TestcheckForEmail(){
        boolean emailvalidate = false;
        id leadid = '00Q5j00000SGvv9EAD';
        string emailid = 'mangal@ymail.com';
        Test.startTest();  
        boolean chkemailvalidate =  DefaultLeadHelper.checkForEmail(emailid,leadid);
        Test.stopTest();
        Assert.areEqual(
            emailvalidate,
            chkemailvalidate,
            'Tested successfully'
        );
        
    }
}