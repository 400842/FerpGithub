({
	doInit: function(component, event, helper) {
        //fetch state picklist values
        helper.fetchStatePickList(component);
        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
        var yyyy = today.getFullYear();
        today = mm + '/' + dd + '/' + yyyy;
        component.set("v.todayDate", today);
        //helper.fetchEntityList(component);
    },
    handleChange : function(component, event, helper) {
		var reasonval= component.get("v.ferpReq.Reason_for_Review");
        //console.log("chosen reason>>>" +reasonval);
        if(reasonval=='My claim was denied ( or partially denied, for example, my plan or issuer is not covering the cost of the claim at an in-network rate)'){
            component.set('v.isClaim',true);
        }else{
            component.set('v.isClaim',false);
        }
	},
    checkboxClicked : function(component, event, helper) {
                //console.log("Expedite reason>>>" +component.get("v.ferpReq.Expedite_Selected"));

		var exval= component.get("v.ferpReq.Expedite_Selected");
       //console.log("Expedite reason>>>" +exval);
        if(exval==true){
            component.set('v.Program_Priority__c','Expedited');
        }else{
            component.set('v.Program_Priority__c','Standard');
        }
	},
    handleClick : function(component, event, helper) {
        helper.getEntities(component,event,helper);
        component.set('v.isHealthPlan',true);
    },
    closeModel : function(component, event, helper) {
        component.set('v.isHealthPlan',false);
    },
    searchTable : function(component, event, helper){   
        var allRecords = component.get("v.edata");
        var searchFilter = event.getSource().get("v.value").toUpperCase();
        var tempArray = [];
        for(var i=0; i < allRecords.length; i++){
            if(allRecords[i].EntityName && allRecords[i].EntityName.toUpperCase().indexOf(searchFilter) != -1){
                tempArray.push(allRecords[i]);
            }
        }
        component.set("v.filteredData",tempArray);
    },
    updateSelectedText: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedRows', selectedRows);
        //console.log('selected row: '+JSON.stringify(component.get("v.selectedRows")));
    },
    addRecord : function (component, event){
        var selectInfo = component.get("v.selectedRows");
        //console.log('selected entity name>> '+selectInfo[0].EntityName);
        component.set('v.ferpReq.Health_Plan',selectInfo[0].EntityName);
        component.set('v.ferpReq.Health_Plan_Street',selectInfo[0].Address_1__c);
        component.set('v.ferpReq.Health_Plan_Apt',selectInfo[0].Address_2__c);
        component.set('v.ferpReq.Health_Plan_City',selectInfo[0].City__c);
        component.set('v.ferpReq.Health_Plan_State',selectInfo[0].State__c);
        component.set('v.ferpReq.Health_Plan_Zip',selectInfo[0].Zip__c);
        component.set('v.ferpReq.Health_Plan_Entity_AddressId',selectInfo[0].Id);
        component.set('v.ferpReq.Health_Plan_Entity_Id',selectInfo[0].Entity__c);
        component.set('v.isHealthPlan',false);
    },
    RequestorasClaimant : function(component, event, helper) {
        helper.CopyRequestor(component,event);        
    },
    ClaimantasPolicy : function(component, event, helper) {
        helper.CopyClaimant(component,event);     
    },
    handleClaim : function(component, event, helper) {
        helper.DisplayClaim(component,event);
    },
    Clearfiles : function(component, event, helper) {
      	//helper.deleteFileInput(component,event); 
          component.set("v.showSelectedFile",false);
            component.set("v.filename",'');

    },
    handlefileschange : function(component, event, helper) {
        if(event.getSource().get("v.files").length>0) {
            var selectedFilename = event.getSource().get("v.files")[0]['name'];
            component.set("v.showSelectedFile",true);
            component.set("v.filename",selectedFilename);
        }
    },
    handlePrint : function(component, event, helper) {
        window.print();
    },
    
    handlesubmit : function(component, event, helper) {
        helper.handleSubmitAction(component,event,helper);
        helper.submitCase(component,event);
    },
    handleUploadSuccess: function (component, event, helper){
        debugger;
        var docRecordId = event.getParam('result');
        var fileName = component.get("v.filename");
       //console.log('@@@@@@'+fileName);
       // alert('@@@@@@'+fileName);
        var action = component.get("c.createAttachment");
        action.setParams({
            fileName: fileName,           
            externalId: docRecordId,
            recordId: component.get("v.caseId")
        });
        action.setCallback(this, function (response) {
            debugger;
            //helper.displaySuccess(component, helper);  
            var state = response.getState();
            //console.log("state>>>" +state);
            if (state === "SUCCESS") {
                console.log("attachment created");
				//Do Nothing
            }
        });
        $A.enqueueAction(action);
    },
    
    AddClaim : function (component, event){
        component.set("v.isClaimModalOpen", true);        
    },
    closeClaimModel: function(component, event, helper) {
      component.set("v.Claim",{'id':component.get("v.claimReq").length,'ClaimName':'','Service_Start_Date':'','Service_End_Date':''});
      component.set("v.isClaimModalOpen", false);
      component.set('v.isClaimEdit', false);
      component.set('v.claimEditRow', '');
   },
   saveClaimDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
      helper.handleClaimSaveAction(component,event,helper);
   },
   claimRowActions : function(component, event, helper) {
        var recId = event.getParam('row').id;
        var actionName = event.getParam('action').name;
        var row = event.getParam('row');
        var data = component.get("v.claimReq");
        var rowIndex = data.indexOf(row);
        //console.log(rowIndex);
        if ( actionName == 'Edit' ) {
            component.set('v.isClaimEdit', true);
            component.set('v.claimEditRow', rowIndex);
            component.set("v.Claim",data[rowIndex]);
            component.set("v.isClaimModalOpen", true);
        } else if ( actionName == 'Delete') {
			data.splice(rowIndex, 1);
            component.set('v.claimReq', data);
        }
    }
    
})