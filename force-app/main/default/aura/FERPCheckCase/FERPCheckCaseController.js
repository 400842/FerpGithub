({
     doInit: function(cmp) {
        document.title = 'Check Case Status';
    },
    searchCase : function(component, event, helper) {
        let action = component.get("c.searchCaseId");
        //console.log('=>'+$A.get("$SObjectType.CurrentUser.Id"));
        action.setParams({
            "caseNumber" : component.get("v.name"),
            "email" : component.get("v.email")
        });
        action.setCallback(this, function(response){
            var state=response.getState();
            var res = response.getReturnValue(); 
            debugger;
            if(state==='SUCCESS'){
                if(res.caseFound == true){
                component.set("v.caseId",res.caseLongId);
                component.set("v.isFound", true);
                component.set("v.isNotfound", false);
                component.set("v.case", res);
                component.set("v.eligibleForFileUpload", res.eligibleForFileUpload);
                component.set("v.filename", '');
                component.set("v.fileUploadSuccess", false);
            }else{
                component.set("v.isNotfound", true);
                component.set("v.isFound", false);
            }
                                 }
            
        });
        $A.enqueueAction(action);
    },
    handlefileschange : function(component, event, helper) {
        debugger;
        if(event.getSource().get("v.files").length>0) {
            component.set("v.hasNoFile",false);
            var selectedFilename = event.getSource().get("v.files")[0]['name'];
            component.set("v.showSelectedFile",true);
            component.set("v.filename",selectedFilename);
            

        }
    },
    saveDocuments : function(component, event, helper) {
        //console.log('In file upload');
        /*var filename = component.get("v.filename");
        if(filename){
        var fileinp = component.find("fileId").get("v.files");
        var file = fileinp[0];
        // call datsi api
        var datsi = component.find('datsi');
        //datsi.upload(file);*/
        var fileUploader = component.find('fileUploader');
        fileUploader.handleClick(component.get("v.caseId"));
       /* }else{
            component.set("v.hasNoFile",true);
        }*/
    },
    handleUploadSuccess: function (component, event, helper){
        debugger;
        var docRecordId = event.getParam('data').docRecId;
        var fileName = component.get("v.filename");
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
                component.set("v.fileUploadSuccess", true);
                component.set("v.eligibleForFileUpload", false);
                //console.log("attachment created");
				//Do Nothing
            }
        });
        $A.enqueueAction(action);
    },
})