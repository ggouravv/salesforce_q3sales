trigger EmailMessageTrigger on EmailMessage (after insert) {
    List<Attachment> attachmentsToInsert = new List<Attachment>();    
    for (EmailMessage emailMessage : Trigger.new) {        
        if (emailMessage.HasAttachment) {
            List<ContentDocumentLink> contentDocumentList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :emailMessage.Id];
            List<ContentVersion> emailAttachments= new List<ContentVersion>();
            List<ContentVersion> emailAttachmentLists= new List<ContentVersion>();
            EmailMessageRelation LeadId= new EmailMessageRelation();
            
            if(emailMessage.RelatedToId==null){
                LeadId = [SELECT Id, EmailMessageId, RelationId FROM EmailMessageRelation Where EmailMessageId=:emailMessage.Id AND RelationType='ToAddress' LIMIT 1];                    
            }
            
            for(Integer i=0;i<contentDocumentList.size();i++){
                Id contentDocumentId=contentDocumentList[i].ContentDocumentId;
                emailAttachments = [SELECT Id, Title, VersionData,ContentDocumentId,FileExtension FROM ContentVersion WHERE ContentDocumentId = :contentDocumentId];
                emailAttachmentLists.Add(emailAttachments[0]);
            }
            
            for (ContentVersion attachment : emailAttachmentLists) {
                Attachment newAttachment = new Attachment();
                if(emailMessage.RelatedToId==null){
                    newAttachment.ParentId = LeadId.RelationId;
                }
                else{
                    newAttachment.ParentId = emailMessage.RelatedToId;
                }
                
                newAttachment.Name = attachment.Title;
                System.Debug('title - ' + attachment.Title);
                newAttachment.Body = attachment.VersionData;
                newAttachment.ContentType=attachment.FileExtension;
                System.Debug('file extension - ' + attachment.FileExtension);
                System.Debug('Content type - ' + newAttachment.ContentType);
                attachmentsToInsert.add(newAttachment);
            }            
        }
    }
    insert attachmentsToInsert;
}