({
	recordClick : function(component, event, helper) {
        //nothing
        if (component.get("v.selectBehavior")=='nothing'){
            return;
        }
        
        //event
        if (component.get("v.selectBehavior")=='record as event'){
            var e = $A.get("e.c:recordSelectedEvent");
            e.setParams({
                "id" : component.get("v.subject.Id"), 
                "record" : component.get("v.subject")
            });
            e.fire();
            return;
        } 
        
        //various navigation options
        var sObjectEvent = $A.get("e.force:navigateToSObject");        		
        var params = {
           "recordId": component.get("v.subject.Id"),
        };        
        if (component.get("v.selectBehavior")=='navigate to detail'){
            console.log('nav to sobject!')
            params.slideDevName = "detail";
        } else if (component.get("v.selectBehavior")=='navigate to feed'){
            params.slideDevName = "chatter";
        } else if (component.get("v.selectBehavior")=='navigate to related'){
            params.slideDevName = "related";
        } 
        sObjectEvent.setParams(params);
        sObjectEvent.fire();
		
    },
    
    //replace this ugly hack with promise.all when we get ES6 figured out
    parallelCheck : function(component, event, helper){
        if (
            $A.util.isUndefinedOrNull(component.get("v.subject"))
        	|| $A.util.isUndefinedOrNull(component.get("v.objectDescribe"))
            || typeof _ === 'undefined'
        ){
            //console.log('not ready');
        } else {
            //console.log('all values present');
            helper.buildKvps(component);
        }
    },
    
})