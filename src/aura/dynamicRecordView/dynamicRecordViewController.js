({
	handleSelected : function(component, event, helper) {
		console.log('event received');
        console.log(event);
        
        $A.createComponent(
            "force:recordView",
            {
                "aura:Id": "singleRecordView",
                "recordId": event.getParam("id")
            },
            function(a){
                //Add the new button to the body array
                if (component.isValid()) {
                    component.set("v.body", a);
                }
            }
        );
    },

})