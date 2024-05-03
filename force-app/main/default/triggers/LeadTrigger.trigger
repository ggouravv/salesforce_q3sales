trigger LeadTrigger on Lead (before insert,before Update) {
    List<Lead> leadList = new List<Lead>();
    List<AssignmentRule> LeadAssignmentRule= [SELECT Id, Active, Name, SobjectType FROM AssignmentRule WHERE SobjectType='Lead' AND Active=true];
    Switch on Trigger.operationType {
        when BEFORE_INSERT {
            for(Lead Leaddata:trigger.new){
                leadList.add(new Lead(id = Leaddata.id));
                if(Leaddata.Company__c == null){
                    id companyID = DefaultLeadHelper.checkForCompany(Leaddata);
                    if(companyID != null){
                        Leaddata.Company__c = companyID;
                        Leaddata.LeadSource = Leaddata.LeadSource == null ? 'web': Leaddata.LeadSource;
                        Leaddata.Method__c = Leaddata.Method__c==null? 'Inbound Marketing': Leaddata.Method__c;
                        Leaddata.Lead_Type__c = Leaddata.Lead_Type__c==null? 'Project': Leaddata.Lead_Type__c;
                    }
                }
                
                if(Leaddata.Method__c != 'Farming'){
                    if(String.isBlank(Leaddata.LinkedIn__c)){// Check for email de-dupe
                        boolean emailvalidate = DefaultLeadHelper.checkForEmailNewRecord(Leaddata.Email);
                        if(emailvalidate == true){
                            Leaddata.addError('Duplicate Email found !');
                        }
                    }else{ // Check for email and linked in both
                        boolean emailLinkedInvalidate = DefaultLeadHelper.checkForEmailLinkedInNewRecord(Leaddata.Email,Leaddata.LinkedIn__c);
                        if(emailLinkedInvalidate == true){
                            Leaddata.addError('Duplicate Email and Linked-In Found !');
                        }
                    }
                }
            }
            
        }
        when BEFORE_UPDATE {
            for(Lead Leaddata:trigger.new){
                leadList.add(new Lead(id = Leaddata.id));
                if(Leaddata.Method__c != 'Farming'){ 
                    if(String.isBlank(Leaddata.LinkedIn__c)){// Check for email de-dupe
                        boolean emailvalidate = DefaultLeadHelper.checkForEmail(Leaddata.Email,Leaddata.Id);
                        if(emailvalidate == true){
                            Leaddata.addError('Record can not be saved. Duplicate Email found !');
                        }
                    }else{ // Check for email and linked in both
                        boolean emailLinkedInvalidate = DefaultLeadHelper.checkForEmailLinkedIn(Leaddata.Email,Leaddata.LinkedIn__c,Leaddata.Id);
                        if(emailLinkedInvalidate == true){
                            Leaddata.addError('Duplicate Email and Linked-In Found !');
                        }
                    }
                }
            }
            for(AssignmentRule LeadRule:LeadAssignmentRule){
                if(LeadRule.Name !='Standard'){
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.assignmentRuleHeader.AssignmentRuleId = LeadRule.Id;
                    //System.Debug(dmo.assignmentRuleHeader.AssignmentRuleId);

                    //dmo.assignmentRuleHeader.useDefaultRule = true;
                    //System.Debug('2');
                    Database.update(leadList, dmo);
                }
            }
        }       
    }    
}