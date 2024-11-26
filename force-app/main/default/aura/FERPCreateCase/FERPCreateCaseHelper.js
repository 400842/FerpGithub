({
    CopyRequestor : function(component,event) {
        var isAsRequestor = component.find("Requestor").get("v.checked");
        //console.log("is same as requestor checked>>>" +isAsRequestor);
        
        if(isAsRequestor == true){
            component.set('v.ferpReq.Claimant_First_Name',component.get("v.ferpReq.Requestor_First_Name"));            
            component.set('v.ferpReq.Claimant_Middle_Name',component.get("v.ferpReq.Requestor_Middle_Name"));
            component.set('v.ferpReq.Claimant_Last_Name',component.get("v.ferpReq.Requestor_Last_Name"));
            component.set('v.ferpReq.Claimant_Street',component.get("v.ferpReq.Requestor_Street"));
            component.set('v.ferpReq.Claimant_Apt',component.get("v.ferpReq.Requestor_Apt"));
            component.set('v.ferpReq.Claimant_City',component.get("v.ferpReq.Requestor_City"));
            component.set('v.ferpReq.Claimant_State',component.get("v.ferpReq.Requestor_State"));
            component.set('v.ferpReq.Claimant_Zip',component.get("v.ferpReq.Requestor_Zip"));
            component.set('v.ferpReq.Claimant_County',component.get("v.ferpReq.Requestor_County"));
            component.set('v.ferpReq.Claimant_Email',component.get("v.ferpReq.Requestor_Email"));
            component.set('v.ferpReq.Claimant_Phone',component.get("v.ferpReq.Requestor_Phone"));
            component.set('v.ferpReq.Claimant_Fax',component.get("v.ferpReq.Requestor_Fax"));
        }else{
            component.set('v.ferpReq.Claimant_First_Name','');            
            component.set('v.ferpReq.Claimant_Middle_Name','');
            component.set('v.ferpReq.Claimant_Last_Name','');
            component.set('v.ferpReq.Claimant_Street','');
            component.set('v.ferpReq.Claimant_Apt','');
            component.set('v.ferpReq.Claimant_City','');
            component.set('v.ferpReq.Claimant_State','');
            component.set('v.ferpReq.Claimant_Zip','');
            component.set('v.ferpReq.Claimant_County','');
            component.set('v.ferpReq.Claimant_Email','');
            component.set('v.ferpReq.Claimant_Phone','');
            component.set('v.ferpReq.Claimant_Fax','');
        }
    },
    CopyClaimant : function(component,event){
        var isAsClaimant = component.find("Claimant").get("v.checked");
        //console.log("is same as requestor checked>>>" +isAsClaimant);
        
        if(isAsClaimant == true){
            component.set('v.ferpReq.Policy_First_Name',component.get("v.ferpReq.Claimant_First_Name"));
            component.set('v.ferpReq.Policy_Holder_Middle_Name',component.get("v.ferpReq.Claimant_Middle_Name"));
            component.set('v.ferpReq.Policy_Holder_Last_Name',component.get("v.ferpReq.Claimant_Last_Name"));
            component.set('v.ferpReq.Policy_Holder_Street',component.get("v.ferpReq.Claimant_Street"));
            component.set('v.ferpReq.Policy_Holder_Apt',component.get("v.ferpReq.Claimant_Apt"));
            component.set('v.ferpReq.Policy_Holder_City',component.get("v.ferpReq.Claimant_City"));
            component.set('v.ferpReq.Policy_Holder_State',component.get("v.ferpReq.Claimant_State"));
            component.set('v.ferpReq.Policy_Holder_Zip',component.get("v.ferpReq.Claimant_Zip"));
            component.set('v.ferpReq.Policy_Holder_County',component.get("v.ferpReq.Claimant_County"));
            component.set('v.ferpReq.Policy_Holder_Email',component.get("v.ferpReq.Claimant_Email"));
            component.set('v.ferpReq.Policy_Holder_Phone',component.get("v.ferpReq.Claimant_Phone"));
            component.set('v.ferpReq.Policy_Holder_Fax',component.get("v.ferpReq.Claimant_Fax"));
        }else{
            component.set('v.ferpReq.Policy_First_Name','');
            component.set('v.ferpReq.Policy_Holder_Middle_Name','');
            component.set('v.ferpReq.Policy_Holder_Last_Name','');
            component.set('v.ferpReq.Policy_Holder_Street','');
            component.set('v.ferpReq.Policy_Holder_Apt','');
            component.set('v.ferpReq.Policy_Holder_City','');
            component.set('v.ferpReq.Policy_Holder_State','');
            component.set('v.ferpReq.Policy_Holder_Zip','');
            component.set('v.ferpReq.Policy_Holder_County','');
            component.set('v.ferpReq.Policy_Holder_Email','');
            component.set('v.ferpReq.Policy_Holder_Phone','');
            component.set('v.ferpReq.Policy_Holder_Fax','');
        }
    },
    DisplayClaim : function(component,event){
        component.set("v.columns", [
            {label: 'Claim Number', fieldName: 'ClaimName', type: 'text'},
            {label: 'Start Date Of Service', fieldName: 'Service_Start_Date', type: 'date-local'},
            {label: 'End Date Of Service', fieldName: 'Service_End_Date', type: 'date-local'},
            {label: '', initialWidth: 90, type: 'button', typeAttributes:{  name: 'Edit',label: { fieldName: 'Edit'}, iconName: 'utility:edit', iconPosition: 'left'}},
            {label: '', initialWidth: 90, type: 'button', typeAttributes:{ name: 'Delete',label: { fieldName: 'Delete'}, iconName: 'utility:delete', iconPosition: 'left'}}
        ]);
        var clms = component.get("v.claimReq");
        //console.log('clms=>'+JSON.stringify(clms));
        //console.log('claim=>'+JSON.stringify(component.get("v.Claim")));
        component.set('v.duplicateClaim', false);
        var currClaim = component.get("v.Claim");
        for ( var i = 0; i < clms.length; i++ ) {
            if(clms[i].ClaimName === currClaim.ClaimName ){
                component.set('v.duplicateClaim', true);
                return;
            }
        }
        if(clms.length > 0){
            clms.push(component.get("v.Claim"));
            component.set('v.claimReq', clms);
        }
        else{
            var clmList = [];
            clmList.push(component.get("v.Claim"));
            component.set('v.claimReq', clmList);
        }
        component.set("v.isClaimModalOpen", false);
        component.set('v.isClaimEdit', false);
        component.set('v.claimEditRow', '');
        component.set("v.Claim",{'id':component.get("v.claimReq").length,'ClaimName':'','Service_Start_Date':'','Service_End_Date':''});
    },
    deleteFileInput : function(component,event){
        var fileInput = component.find("fileId");
        fileInput.destroy();
    },
    handleSubmitAction : function(component, event, helper) {
        var allValid = component.find("reqfield").reduce(function (isValidSoFar, inputCmp) {
            inputCmp.reportValidity();
            
            return isValidSoFar && inputCmp.checkValidity();
        }, true);
    },
    handleClaimSaveAction : function(component, event, helper) {
        component.set('v.duplicateClaim', false);
        
        var allValid = component.find("reqfield1").reduce(function (isValidSoFar, inputCmp) {
            inputCmp.reportValidity();
            //console.log('t>> '+isValidSoFar && inputCmp.checkValidity());
            return isValidSoFar && inputCmp.checkValidity();
        }, true);
        if(allValid == true){
            var isClaimEdit = component.get("v.isClaimEdit");
            var claimData = component.get("v.Claim");
            //console.log('claimData=>'+JSON.stringify(claimData));
            if(new Date(claimData.Service_Start_Date) >= new Date(claimData.Service_End_Date)) {
                component.set("v.isClaimError", true);
            }else if (new Date(claimData.Service_Start_Date) < new Date(claimData.Service_End_Date)){
                component.set("v.isClaimError", false);
            }
            if(component.get("v.isClaimError") == true){
                component.set('v.claimErrorMsg', 'Service End Date must be after Service Start Date');
            }
            else{
                if(isClaimEdit == true){
                    var data = component.get("v.claimReq");
                    data.splice(component.get("v.claimEditRow"), 1);
                    component.set('v.claimReq', data);
                }
                this.DisplayClaim(component,event);
                
            }
        }
    },
    submitCase : function(component,event) {
        //console.log('Denial_Notic_Attached@@@'+component.get("v.ferpReq").Denial_Notic_Attached);
        var requestorSectionValid = true;
        var claimantSectionValid = true;
        var pHolderSectionValid = true;
        var hPlanSectionValid = true; 
        var denialInfoSectionValid = true;
        var allValid = component.find("reqfield").reduce(function (isValidSoFar, inputCmp) {
            inputCmp.reportValidity();
            var invalidInputField = inputCmp.get("v.name");
            //console.log('invalidInputField>> ', invalidInputField);
            //console.log('isValidSoFar>> ', isValidSoFar);
            //console.log('inputCmp.checkValidity()>> ', inputCmp.checkValidity());
            if(invalidInputField.includes('requestorSection') && inputCmp.checkValidity() !== true){
                requestorSectionValid = false;
            }
            if(invalidInputField.includes('claimantSection') && inputCmp.checkValidity() !== true){
                claimantSectionValid = false;
            }
            if(invalidInputField.includes('pHolderSection') && inputCmp.checkValidity() !== true){
                pHolderSectionValid = false;
            }
            if(invalidInputField.includes('hPlanSection') && inputCmp.checkValidity() !== true){
                hPlanSectionValid = false;
            }
            if(invalidInputField.includes('denialInfoSection') && inputCmp.checkValidity() !== true){
                denialInfoSectionValid = false;
            }
            return isValidSoFar && inputCmp.checkValidity();
        }, true);
        
        
        
        component.set("v.hasErrorsOnPage" , !allValid);
        if(allValid == true){
            component.set("v.disableActions", false);
            //console.log('in submit calling apex');
            var action = component.get("c.CreateCase");
            let reqPayload = component.get("v.ferpReq");
            action.setParams({
                "ferpReqObj" :reqPayload,
                "claimsList" :component.get("v.claimReq")
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                var res = response.getReturnValue();
                //console.log('state>>' +state);
                //console.log('res=>'+JSON.stringify(res));
                
                if(state === 'SUCCESS'){
                    
                    //debugger;
                    //console.log('response>>' ,res);
                    if(res){
                        var caseIdDisplay;
                        if(res.Case_Number_f__c){
                            caseIdDisplay = res.Case_Number_f__c.substring(
                                res.Case_Number_f__c.indexOf(">") + 1, 
                                res.Case_Number_f__c.lastIndexOf("<")
                            );
                        }
                        document.title = caseIdDisplay;
                        component.set("v.caseIdDisplay",caseIdDisplay);
                        component.set("v.caseId", res.Id);
                        //console.log('created case Id>>>' +res);
                        
                        // return;
                        //debugger;
                        var fileName = component.get("v.filename");
                        //alert('fileName=>'+fileName);
                        //console.log('fileName=>'+fileName);
                          component.set("v.boolCaseCreated",true);
                        this.uploadfile(component,res.Id);
                           
                        


                    }
                } else{
                    //enable actions
                    component.set("v.disableActions", false);
                    //console.log("error>>>" +JSON.stringify(response.getError()));
                }
            });
            $A.enqueueAction(action);
        }else{
            //debugger;
            if(requestorSectionValid === false){
                var elmnt = document.getElementById("reqContent");
                elmnt.scrollIntoView();
                return;
            }else if(claimantSectionValid === false){
                var elmnt = document.getElementById("claimantContent");
                elmnt.scrollIntoView();
                return;
            }
                else if(pHolderSectionValid === false){
                    var elmnt = document.getElementById("pHolderContent");
                    elmnt.scrollIntoView();
                    return;
                }
                    else if(hPlanSectionValid === false){
                        var elmnt = document.getElementById("hPlanContent");
                        elmnt.scrollIntoView();
                        return;
                    }
                        else if(denialInfoSectionValid === false){
                            var elmnt = document.getElementById("denialInfoContent");
                            elmnt.scrollIntoView();
                            return;
                        }
        }
    },
    uploadfile : function(component,recId){
        //debugger;
        //console.log('In file upload');
        //var fileinp = component.find("fileId").get("v.files");
        //var file = fileinp[0];
        // call datsi api
        var fileUploader = component.find('fileUploader');
        fileUploader.handleClick(recId);
    },
    //get state picklist values
    fetchStatePickList: function(component){
        var action = component.get("c.getStatePicklist");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                let statelist = [{value:'',label:'--None--'}];
                let resArray = a.getReturnValue();
                resArray.forEach(elm => statelist.push({value:elm,label:elm}));
                component.set("v.stateList", statelist);
            } 
        });
        $A.enqueueAction(action);
    },
    getEntities : function(component, event, helper){
        component.set("v.ecolumns", [
            {label: 'Health Plan', fieldName: 'EntityName', type: 'text'},
            {label: 'Street Address', fieldName: 'Address_1__c', type: 'text'},
            {label: 'Apt./Ste', fieldName: 'Address_2__c', type: 'text'},
            {label: 'City', fieldName: 'City__c', type: 'text'},
            {label: 'State', fieldName: 'State__c', type: 'text'},
            {label: 'Zip', fieldName: 'Zip__c', type: 'text'}
        ]);
        var action = component.get("c.fetchEntities");
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log('state>>' +state);
            if(state === 'SUCCESS'){
                var rows = response.getReturnValue();
                if(rows){
                    for ( var i = 0; i < rows.length; i++ ) {
                        var row = rows[i];
                        row.EntityName = row.Entity__r.Name;
                    }      
                    component.set("v.edata",rows);
                    component.set("v.filteredData",rows);
                    //console.log('result>>>' +JSON.stringify(v.filteredData));
                    
                }
            } else{
                //console.log("error>>>" +JSON.stringify(response.getError()));
            }
        });
        $A.enqueueAction(action);
    }
})