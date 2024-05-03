@isTest
public class EmailMessageTriggerTest {
    @isTest
    public static void LeadContactEmailMessageTriggerMethod(){
        Messaging.SingleEmailMessage mymail = new Messaging.SingleEmailMessage();
        Lead l1 = new Lead();
        l1.LastName='Amazon';
        l1.Company='Amazon';
        l1.Method__c = 'Inbound Marketing';
        l1.Lead_Type__c = 'Project';
        l1.LeadSource = 'EMail';
        insert l1;
        
        Account a1= new Account();
        a1.Name='Ram';
        insert a1;
        
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Sample Document';
        cv.PathOnClient = 'sample-document.txt';
        cv.VersionData = Blob.valueOf('This is the content of the document.'); 
        insert cv;
        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = l1.Id; 
        cdl.Visibility = 'AllUsers'; 
        insert cdl;
        
        List<Id> AttachmentIds= new List<Id>();
        AttachmentIds.Add(cv.Id);
        
        Test.startTest();
        String[] ToAddress= new String[]{'manishchandwani1212@gmail.com'};
            
        mymail.setToAddresses(ToAddress);
        mymail.setWhatId(a1.Id);
        mymail.setEntityAttachments(AttachmentIds);
        mymail.setHtmlBody('<p> This email has been sent through Apex</p>');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mymail });
        
        
        Test.stopTest();
        
        List<EmailMessage> sentEmails = [SELECT Id, ToAddress, Subject,HasAttachment FROM EmailMessage];
        System.assertEquals(1, sentEmails.size());
        System.assertEquals(sentEmails[0].HasAttachment,true);
        List<Attachment> att=[SELECT Id, Name, Body FROM Attachment where Name='Sample Document'];
        System.assertEquals(1, att.size());
    }
}