public class EmailToLead implements Messaging.InboundEmailHandler {
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String mySubject = email.subject.toLowerCase();
        String myBody = email.plainTextBody.toLowerCase();
        String s = 'request'; // The search string used in the subject line and body.
        
        Boolean checkSubject, checkBody;
        checkSubject = mySubject.contains(s);
        checkBody = myBody.contains(s);
        String firstName = (email.fromname.substring(0, email.fromname.indexof(' '))).trim();
        String lastName = (email.fromname.substring(email.fromname.indexof(' '))).trim();
        String emailId =(email.fromAddress).trim();
        
        List<Lead> matchingLead = [SELECT Id FROM Lead WHERE FirstName = :firstName 
                                   AND LastName = :lastName AND Email = :emailId LIMIT 1];
        if (checkSubject == true || checkBody == true || !matchingLead.isEmpty()) {
            try {
                if(matchingLead.isEmpty()){
                    Lead led = new Lead();
                    led.FirstName = firstName;
                    led.LastName = lastName;
                    led.Title = email.subject;
                    led.Company = 'XYZ';
                    led.Status = 'Open - Not Contacted';
                    led.LeadSource = 'Email';
                    led.Email = emailId;
                    led.Description = email.plainTextBody;
                    led.Method__c = 'Inbound Marketing';
                    led.Lead_Type__c = 'Project';
                    insert led;
                    
                    for (Messaging.Inboundemail.BinaryAttachment attachment : email.binaryAttachments) {
                        Attachment attachmentRecord = new Attachment(
                            ParentId = led.Id,
                            Name = attachment.fileName,
                            Body = attachment.body
                        );
                        insert attachmentRecord;
                    }
                } else {
                    for (Messaging.Inboundemail.BinaryAttachment attachment : email.binaryAttachments) {
                        Attachment attachmentRecord = new Attachment(
                            ParentId = matchingLead[0].Id,
                            Name = attachment.fileName,
                            Body = attachment.body
                        );
                        insert attachmentRecord;
                    }
                }
                
                result.success = true;
                
            } catch (Exception e) {
                System.debug('Lead Creation Issue: ' + e);
                result.success = false;
            } 
        } else {
            System.debug('No matching string was found in the subject or body line.' );
        }
        return result;
    }
}