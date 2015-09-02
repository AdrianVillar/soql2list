({        
    query : function(component, soql, returnValue){
        var action = component.get("c.query");
        action.setParams({
            "soql" : soql            
        });
        
        action.setCallback(this, function (a){
            console.log("result in callback:");
            var output = JSON.parse(a.getReturnValue());
            console.log(output.records);
            
            component.set("v."+returnValue, output.records);
        });
        $A.enqueueAction(action);
    },
    
    describe : function (component, objectName, returnValue){
        //	public static String describe(String objtype) {
		var action = component.get("c.describe");
        action.setParams({
            "objtype" : objectName            
        });
        action.setCallback(this, function (a){
            console.log("result in callback:");
            var output = JSON.parse(a.getReturnValue());

            console.log(output.fields);
            component.set("v."+returnValue, output.fields);
        });
        $A.enqueueAction(action);
    },
    
    retrieve : function(sObject, fieldList, whereClause, orderyBy, limit) {
        //retrieve(String objtype, String id, String fieldlist)
	}
    
    //helpers for helpers
    
    
    //logger function
})