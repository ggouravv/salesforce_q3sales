@isTest
public class EmailToLeadTest {
    @isTest
    static void testHandleInboundEmail_CreateNewLead() {
        // Create a test inbound email
        Messaging.InboundEmail email = createTestInboundEmail('Rishabh Anand', 'rishabh@example.com', 'Test Subject', 'This is a test body with request');

        // Attachments
        Blob attachmentBody = Blob.valueOf('Test Attachment Content');
        Messaging.InboundEmail.BinaryAttachment testAttachment = new Messaging.InboundEmail.BinaryAttachment();
        testAttachment.fileName = 'TestAttachment.txt';
        testAttachment.body = attachmentBody;
        email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>{ testAttachment };
            
        // Start the test
        Test.startTest();

        // Calling the handleInboundEmail method
        EmailToLead handler = new EmailToLead();
        Messaging.InboundEmailResult result = handler.handleInboundEmail(email, null);

        // End the test
        Test.stopTest();

        // Verifying Result
        System.assertEquals(true, result.success, 'Inbound email handling should be successful');
    }

    @isTest
    static void testHandleInboundEmail_UpdateExistingLead() {
        // Create a test lead
        Lead existingLead = new Lead(
            FirstName = 'Rishabh',
            LastName = 'Anand',
            Email = 'rishabh@example.com',
            Company = 'Testing Company',
            Status = 'Open - Not Contacted',
            LeadSource = 'Email',
            Lead_Type__c = 'Project',
            Method__c = 'Inbound Marketing'
        );
        insert existingLead;

        // Create a test inbound email
        Messaging.InboundEmail email = createTestInboundEmail('Rishabh Anand', 'rishabh@example.com', 'Test Subject', 'This is a test body with request');

        // Attachments
        Blob attachmentBody = Blob.valueOf('Test Attachment Content');
        Messaging.InboundEmail.BinaryAttachment testAttachment = new Messaging.InboundEmail.BinaryAttachment();
        testAttachment.fileName = 'TestAttachment.txt';
        testAttachment.body = attachmentBody;
        email.binaryAttachments = new List<Messaging.InboundEmail.BinaryAttachment>{ testAttachment };
        
        // Start the test
        Test.startTest();

        // Calling the handleInboundEmail method
        EmailToLead handler = new EmailToLead();
        Messaging.InboundEmailResult result = handler.handleInboundEmail(email, null);

        // End the test
        Test.stopTest();

        // Verifying Result
        System.assertEquals(true, result.success, 'Inbound email handling should be successful');
    }

    @isTest
    static void testHandleInboundEmail_ExceptionHandling() {
        // Creating test data
        Messaging.InboundEnvelope testEnvelope = new Messaging.InboundEnvelope();
        Messaging.InboundEmail testEmail = new Messaging.InboundEmail();
        testEmail.subject = 'Test Request';
        testEmail.plainTextBody = 'This is just for testing purposes.';
        testEnvelope.fromAddress = 'test@example.com';
            
        EmailToLead handler = new EmailToLead();
        Messaging.InboundEmailResult result;
        
        // Start the test
        Test.startTest();
        
        // Calling the handleInboundEmail method
        result = handler.handleInboundEmail(testEmail, testEnvelope);
        
        // End the test
        Test.stopTest();

        // Verifing result
        System.assertEquals(false, result.success, 'Expected success to be false');
    }
    
    private static Messaging.InboundEmail createTestInboundEmail(
        String fromName, String fromAddress, String subject, String plainTextBody) {
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.fromname = fromName;
        email.fromAddress = fromAddress;
        email.subject = subject;
        email.plainTextBody = plainTextBody;
        return email;
    }
}