({
	buildKvps : function(component) {
		var subject = component.get("v.subject"),
			describe = component.get("v.objectDescribe"),        	
            kvps = [];
            _.forEach(subject, function(value, key){
                if (key != 'attributes' && key != 'Id'){
                    $A.log('this is ok -- ' + key + ":"  + value);
                    $A.log(describe);
                    if (!$A.util.isUndefinedOrNull(describe)){
                        kvps.push({"key" : key, "value" : value });                                   
                    } else {
                        
                        var friendlyKey = _.pluck(_.filter(describe, {"name" : key}), 'label');
                        var fieldType = _.pluck(_.filter(describe, {"name" : key}), 'type');                   
                        //var formattedValue;  
                        //if (fieldType == 'datetime') {formattedValue = }
                        //if (fieldType == 'date') {formattedValue = }
                        
                        kvps.push({"key" : friendlyKey, "value" : value });               
                    }
                }
            });	
        
            component.set("v.kvps" , kvps);
            //TODO: handling for special fields types (date/datetime, geolocation)
	}
})