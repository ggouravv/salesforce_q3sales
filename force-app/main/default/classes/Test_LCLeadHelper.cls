@IsTest
public class Test_LCLeadHelper {
	@IsTest
    public static void GetCompanyData(){
        Test.startTest();
       	Company__c comp1 = new Company__c(Name='MyComp1');
        insert comp1;
        Company__c comp2 = LC_LeadHelper.getCompanyData(comp1.Id);
        Test.stopTest();
        Assert.areEqual(
            comp2,
            comp1,
            'Test is successfull.'
        );
	}
    
    @IsTest
    public static void LeadTriggerTest() {
		Test.startTest();
        Company__c comp1 = new Company__c(Name='MyComp1');
        insert comp1;
        List<Lead> listLead = new List<Lead>();
        Lead l1 = new Lead();
        l1.Company__c = comp1.Id;
        l1.State = 'Open - Not Contacted';
        l1.LastName = 'Lead1';
        l1.Email = 'test1@gmail.com';
        l1.LinkedIn__c = 'www.test1-linkedin.com';
        l1.Company = comp1.Name;
        l1.Method__c = 'Farming';
        l1.Lead_Type__c	 = 'Project';
        l1.LeadSource = 'Web';
        listLead.add(l1);
        Lead l2 = new Lead();
        l2.Company__c = comp1.Id;
        l2.State = 'Open - Not Contacted';
        l2.LastName = 'Lead1';
        l2.Email = 'test2@gmail.com';
        l2.LinkedIn__c = 'www.test2-linkedin.com';
        l2.Company = comp1.Name;
        l2.Method__c = 'Hunting';
        l2.Lead_Type__c = 'Project';
        l2.LeadSource = 'Web';
        listLead.add(l2);
        Lead l3 = new Lead();
        l3.State = 'Open - Not Contacted';
        l3.LastName = 'Lead1';
        l3.Email = 'test3@gmail.com';
        l3.Method__c = 'Hunting';
        l3.Company = 'web';
        l3.Lead_Type__c = 'Project';
        l3.LeadSource = 'Web';
        listLead.add(l3);
        insert listLead;
        update listLead;
    }
}