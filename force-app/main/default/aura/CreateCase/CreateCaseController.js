({	
    doInit: function(component, event, helper) {
        component.set("v.spinner", true); 
        //console.log("calling apex: ");
        var action = component.get("c.getCaseRecordTypeID");
        action.setCallback(this, function(response) {
            component.set("v.spinner", false); 
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.recordTypeId",response.getReturnValue());
            }
            else {
                //console.log("Failed with state: " + state);
            }
        });
        
        $A.enqueueAction(action);
    },
    handleSuccess: function(component, event, helper) {
        component.set("v.showSpinner", false);
        var payload = event.getParams().response;
        if (component.get("v.fromVfp") === "FromVFP") {                            
            var myEvent = $A.get("e.c:SendDataToVFPage");
            myEvent.setParams({
                currentRecId: payload.id                                
            });
            myEvent.fire();            
        } 
        else {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                type: "Success",
                message: "Case Created Successfully.",
                mode: "dismissable"
            });
            toastEvent.fire();   
            //console.log("Name", payload.Name);
            var sObjectEvent = $A.get("e.force:navigateToSObject");
            sObjectEvent.setParams({
                recordId: payload.id
            });
            sObjectEvent.fire();
        }        
    }, 
    errorInformation: function(component, event, helper) {
        component.set("v.showSpinner", false);
        //console.log("Inside Error handling");
        var eventName = event.getName();
        var eventDetails = event.getParam("error");
        //console.log("Error Event received" + eventName);
        var errorParamsRaw = event.getParams();
        var errorParamsJSON = JSON.stringify(errorParamsRaw);
        //console.log(errorParamsJSON);
        if (!errorParamsJSON.includes("Received unexpected value during emit")) {
            $A.util.removeClass(component.find("messages"), "slds-hide");
        }
    },
    
    onAccountSelect: function(component, event, helper) {
        var newValue = component.find("AccountId").get("v.value");
        component.set("v.AccountId", newValue);
        //console.log ("Account Id:"+ component.get("v.AccountId"));
        
        var action = component.get("c.getReviewType");
        action.setParams({
            AccountId: component.get("v.AccountId")
        });
        action.setCallback(this, function(response) {
            component.set("v.listOfReviewTypes", response.getReturnValue());
            //console.log("listOfReviewTypes " + component.get("v.listOfReviewTypes"));
            var res = response.getReturnValue();
            var isEmpty = $A.util.isEmpty(component.get("v.listOfReviewTypes"));
            if (!isEmpty) {                
                component.set("v.ReviewTypeExist", true);
                //console.log("firstvalue " + res[0].Id);                
            } else {
                component.set("v.ReviewTypeExist", false);
            }           
        });
        $A.enqueueAction(action);
        
        var action1 = component.get("c.getAppealType");
        action1.setParams({
            AccountId: component.get("v.AccountId")
        });
        
        action1.setCallback(this, function(response) {
            component.set("v.listOfAppealTypes", response.getReturnValue());
            //console.log("listOfAppealTypes " + component.get("v.listOfAppealTypes"));
            var res = response.getReturnValue();
            var isEmpty = $A.util.isEmpty(component.get("v.listOfAppealTypes"));
            if (!isEmpty) {                
                component.set("v.AppealTypeExist", true);
                //console.log("firstvalue " + res[0].Id);                
            } else {
                component.set("v.AppealTypeExist", false);
            }           
        });
        $A.enqueueAction(action1);

        
        var action2 = component.get("c.getAppealCategory");
        action2.setParams({
            AccountId: component.get("v.AccountId")
        });
        
        action2.setCallback(this, function(response) {
            component.set("v.listOfAppealCategory", response.getReturnValue());
            //console.log("listOfAppealCategory " + component.get("v.listOfAppealCategory"));
            var res = response.getReturnValue();
            var isEmpty = $A.util.isEmpty(component.get("v.listOfAppealCategory"));
            if (!isEmpty) {                
                component.set("v.AppealCategoryExist", true);
                //console.log("firstvalue " + res[0].Id);                
            } else {
                component.set("v.AppealCategoryExist", false);
            }           
        });
        $A.enqueueAction(action2);
    },     
    onAtypeSelect: function(component, event, helper) {  
        var newValue = component.find("aType").get("v.value");
        component.set("v.AppealType", newValue);
        //console.log ("AppealType:"+ component.get("v.AppealType"));
    },
    onaCatSelect: function(component, event, helper) {  
        var newValue = component.find("aCategory").get("v.value");
        component.set("v.AppealCategory", newValue);
        //console.log ("AppealCategory:"+ component.get("v.AppealCategory"));
    },
    onRtypeSelect: function(component, event, helper) {  
        var newValue = component.find("rType").get("v.value");
        component.set("v.ReviewType", newValue);
        //console.log ("ReviewType:"+ component.get("v.ReviewType"));

        var action = component.get("c.getPriorityType");
        action.setParams({
            ReviewTypeId: component.get("v.ReviewType")
        });
        action.setCallback(this, function(response) {
            component.set("v.listOfPriorityTypes", response.getReturnValue());
            //console.log("listOfPriorityTypes " + component.get("v.listOfPriorityTypes"));
            var res = response.getReturnValue();
            var isEmpty = $A.util.isEmpty(component.get("v.listOfPriorityTypes"));
            if (!isEmpty) {
                component.set("v.currentValueP", res[0].Id); //This will set the 1st value as current one
                component.set("v.PriorityTypeExist", true);
                //console.log("firstvalue " + res[0].Id);
                //console.log("currentValueP" + component.get("v.currentValueP"));
            } else {
                component.set("v.PriorityTypeExist", false);
            }            
        });
        $A.enqueueAction(action);       
    },
    showRequiredFields: function(component) {
        $A.util.removeClass(component.find("AccountId"), "none");
    },
    handleCancel: function(component, event, helper) {
        component.find("AccountId").set("v.value", "");
        //component.find("rType").set("v.value", "");
        //component.find("pType").set("v.value", "");
        //component.find("aType").set("v.value", "");
        //component.find("aCategory").set("v.value", "");
        component.set("v.ReviewTypeExist", false);
        component.set("v.PriorityTypeExist", false);
        component.set("v.AppealTypeExist", false);
        component.set("v.AppealCategoryExist", false);        
        component.set("v.isError", false);
    },
    handlesave: function(component, event, helper) {
        var isAccount = $A.util.isEmpty(component.find("AccountId").get("v.value"));        
        //console.log("isAccount "+isAccount);
        if (isAccount) {
            helper.showError(component, "Program Name is required");            
            return false;    
        }        
        if (component.get("v.ReviewTypeExist")) {
            var rType = $A.util.isEmpty(component.find("rType").get("v.value"));
            if (rType) {
                helper.showError(component, "Review Type is required");            
                return false;
            }
        }  
        if (component.get("v.PriorityTypeExist")) {
            var pType = $A.util.isEmpty(component.find("pType").get("v.value"));
            if (pType) {
                helper.showError(component, "Priority Type is required");            
                return false;
            }
        }    
        //check if the program exists on west org
        //helper.isProgramAlreadyExists(component, helper);
        component.find('editForm').submit(); //will be moved to isProgramAlreadyExists after poc
                
    },   
    onPtypeSelect: function(component, event, helper) {
        var pValue = component.find("pType").get("v.value");
        component.set("v.PriorityType", pValue);
        //console.log ("PriorityType:"+ component.get("v.PriorityType"));

        var action = component.get("c.getBillingFeeAmount");
        action.setParams({
            PriorityId: component.get("v.PriorityType")
        });
        action.setCallback(this, function(response) {
            component.set("v.listOffee", response.getReturnValue());
            //console.log("listOffee " + component.get("v.listOffee"));
            var res = response.getReturnValue();
            var isEmpty = $A.util.isEmpty(component.get("v.listOffee"));
            
            if (isEmpty) {
                component.set("v.feeAmount", "0.00");                
            }          
            else {
                //console.log("Fee Amount: "+res[0].Fee_Amount__c);
                component.set("v.feeAmount",res[0].Fee_Amount__c);
                component.set("v.feeUnit",res[0].Unit__c);
                //console.log("Fee Amount: "+ component.get("v.feeAmount"));
            }       
        });
        $A.enqueueAction(action);    

        var actionr = component.get("c.getReviewFeeAmount");
        actionr.setParams({
            PriorityId: component.get("v.PriorityType")
        });
        actionr.setCallback(this, function(response) {
            component.set("v.listOfRfee", response.getReturnValue());
            //console.log("listOfRfee " + component.get("v.listOfRfee"));
            var res = response.getReturnValue();
            var isEmpty = $A.util.isEmpty(component.get("v.listOfRfee"));
            
            if (isEmpty) {
                component.set("v.rfeeAmount", "0.00");                
            }          
            else {
                //console.log("Fee Amount: "+res[0].Fee_Amount__c);
                component.set("v.rfeeAmount",res[0].Fee_Amount__c);
                component.set("v.rfeeUnit",res[0].Unit__c);
                //console.log("Review Fee Amount: "+ component.get("v.rfeeAmount"));
            }       
        });
        $A.enqueueAction(actionr);              
    }    
})