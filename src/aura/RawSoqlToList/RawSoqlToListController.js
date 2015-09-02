({
	doInit : function(component, event, helper) {
        helper.query(component, component.get("v.soql"), "results");            
        helper.describe(component, component.get("v.objectType"), "describe"); 
	}
})