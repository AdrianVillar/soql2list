({
    buildKvps : function(component) {
        //console.log('building KVPs')
        var subject = component.get("v.subject");
        var	describe = component.get("v.objectDescribe");        	
        var kvps = [];
        var allKvps = [];
        
        //new version, driven from the describe
        _.forEach(describe, function(value, key){
            if (key != 'attributes' && key != 'Id'){
                allKvps.push({"key" : value.label, "value" : subject[key]});
            } 
        });
        //console.log(allKvps)
        component.set("v.allKvps" , allKvps);

        //old version , driven from the record
        _.forEach(subject, function(value, key){
            if (key != 'attributes' && key != 'Id'){
                //console.log('this is ok -- ' + key + ":"  + value);                
                //var friendlyKey = _.pluck(_.filter(describe, {"name" : key}), 'label');
                var friendlyKey = describe[key].label;
                if (describe[key].type == 'date'){
                    console.log('found a date');
                }
                if (describe[key].type == 'datetime'){
                    console.log('found a datetime');
                }
                if (describe[key].type == 'geolocation'){
                    console.log('found a geolocation');
                }
                kvps.push({"key" : friendlyKey, "value" : value });               
            }
        });
        
        //console.log(kvps);
        component.set("v.kvps" , kvps);
    }
})