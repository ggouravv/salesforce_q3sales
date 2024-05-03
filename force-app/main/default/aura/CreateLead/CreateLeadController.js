({
    handleCreateLoad: function(component, event, helper){
        var lastName = component.find('LastName').get('v.value');
        var firstName = component.find('FirstName').get('v.value');
        var title = '';
        if(lastName){
            title = 'Edit ' + lastName + ' ' + firstName || '';
        }else{
            title = 'New Lead';
        }
        component.set('v.recordTitleName', title);
    },
    
    oncompanyChange : function(component, event, helper) {
        
        var companyID = component.find("companyName").get('v.value');
        if(companyID == ''){
            component.find('Company').set('v.value','');
            component.find('PostalCode').set('v.value','');
            component.find('City').set('v.value','');
            component.find('Street').set('v.value','');
            component.find('State').set('v.value','');
            component.find('Country').set('v.value','');
            component.find('Industry').set('v.value','');
            component.find('No_of_Employees__c').set('v.value','');
            component.find('WorkPhone__c').set('v.value','');
            component.find('Website').set('v.value','');
        }
        var servercall = component.get("c.getCompanyData");        
        servercall.setParams({"companyID":companyID});
        servercall.setCallback(this,function(response){
            var status = response.getState();
            if(status=='SUCCESS'){
                var responsedata = response.getReturnValue();
                component.find('Company').set('v.value',responsedata.Name);
                component.find('PostalCode').set('v.value',responsedata.Postal_Code__c);
                component.find('City').set('v.value',responsedata.City__c);
                component.find('Street').set('v.value',responsedata.Street__c);
                component.find('State').set('v.value',responsedata.State_Province__c);
                component.find('Country').set('v.value',responsedata.Country__c);
                component.find('Industry').set('v.value',responsedata.Industry__c);
                component.find('No_of_Employees__c').set('v.value',responsedata.No_of_Employees__c);
                component.find('WorkPhone__c').set('v.value',responsedata.HQ_Phone__c);
                component.find('Website').set('v.value',responsedata.Website__c);
            }
        });
        $A.enqueueAction(servercall);       
    },
    handleCancel : function (component, event, helper) {
        var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                //"listViewId": '00B5j00000Yy9RuEAJ',
                "listViewName": 'Recently Viewed Leads',
                "scope": "Lead"
            });
            navEvent.fire();
    },
    handleSuccess : function(component, event, helper) {
        var LastName = component.find("LastName").get('v.value');
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Lead "+ LastName,
            //"message": "Lead "+ LastName+ " was created/Updated.",
            "type": "success"
        });
        toastEvent.fire();
        
         var params = event.getParams();
         component.find("navService").navigate({
            "type": "standard__recordPage",
            "attributes": {
                "recordId": params.response.id,
                "objectApiName": "Lead",
                "actionName": "view"
            }
        });
    },
    
    // Handle Submit
    handleError: function(component, event, helper) {
        var error = event.getParams();
        var errorMessage = event.getParam("detail");
        $A.get("e.force:showToast")
        .setParams({
            type: 'error',
            mode: 'pester',
            message: errorMessage,
            duration:'5000',
        }).fire();
    }
    /*
    //Create New Company
    createNewCompany : function(component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Company__c",
            "noOverride": false,
            "navigationLocation": "LOOKUP",
            "panelOndestroycallback":  function(event) {
                
                console.log("calllback0");
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "c:CreateLead"
                    
                });
                evt.fire();
                console.log("calllback1");
            }   
            
            
        });
        
        
        createRecordEvent.fire();
        console.log("calllback2");



        
        
           
    }*/
    
    
    
})