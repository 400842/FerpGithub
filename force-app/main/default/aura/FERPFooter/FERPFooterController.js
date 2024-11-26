({
	doInit : function(component, event, helper) {
		var urlString = window.location.href;
 		var baseURL = urlString.substring(0, urlString.indexOf("/s"));
        console.log("base url>>>" +baseURL);
 		component.set("v.url", baseURL);
	}
})