({
	openNav : function(component, event, helper) {
		component.set("v.IsnavOpen",true);
	},
    onInit : function(component, event, helper) {
		var url = window.location.href;
        if(url.includes('eligible')){
            component.set("v.eligibleClass",'yellowText');
            component.set("v.homeClasss",'whiteText');
        }
        if(url.includes('external-reviews')){
            component.set("v.extRevClass",'yellowText');
            component.set("v.homeClasss",'whiteText');
        }
        if(url.includes('requestreview')){
            component.set("v.reqRevClass",'yellowText');
            component.set("v.homeClasss",'whiteText');
        }
        if(url.includes('checkcase')){
            component.set("v.checkCaseClass",'yellowText');
            component.set("v.homeClasss",'whiteText');
        }
        if(url.includes('forms')){
            component.set("v.formClass",'yellowText');
            component.set("v.homeClasss",'whiteText');
        }
        if(url.includes('faq')){
            component.set("v.faqClass",'yellowText');
            component.set("v.homeClasss",'whiteText');
        }
        if(url.includes('resources')){
            component.set("v.resourceClass",'yellowText');
            component.set("v.homeClasss",'whiteText');
        }
	},
})