({
	validate : function(component,event) {
        //console.log("entered validate");
        var caseval = component.get("v.Name");
        var emailval = component.get("v.Email");
        
        if(caseval == ""){
            component.set("v.isCase",true);
        }
        if(emailval == ""){
            component.set("v.isEmail",true);
        }
        //console.log("validate function results>>>" +caseval);
        return !(component.get("v.isCase")) && !(component.get("v.isEmail"));
	},
    caseSearch : function(component){
        debugger;
        var action = component.get("c.SearchCase");
            //console.log("Name>>>"+component.get("v.Name"));
            action.setParams({
                "CaseNumber" : component.get("v.Name"),
                "Email" : component.get("v.Email")
            });
            action.setCallback(this, function(response){
               var state=response.getState();
                if(state==='SUCCESS'){
                    var res = response.getReturnValue();
                    if(res){
                        component.set("v.isNotfound", false);
                        component.set("v.isFound", true);
                    }else{
                        component.set("v.isNotfound", true);
                        component.set("v.isFound", false);
                    }
                }
            });
            $A.enqueueAction(action);
    }
})