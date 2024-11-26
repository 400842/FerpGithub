({
	handleSuccess: function (component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "Changes saved successfully.",
            "type": "SUCCESS"
        });
        toastEvent.fire();
        // reloading to see latest changes in determination tab
        setTimeout(function(){ window.location.reload(); }, 2000);
        
    }
})