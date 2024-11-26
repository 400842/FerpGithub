({
    navigateTo: function(component, recId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recId
        });
        navEvt.fire();
    },
    showError: function(component,msg){
        component.set("v.message",msg);
        component.set("v.showSpinner",false);
        component.set("v.isError",true);
        component.set("v.isValid",false);  
    }
    
})