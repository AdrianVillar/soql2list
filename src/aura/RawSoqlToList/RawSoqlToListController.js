({
    doInit : function(component, event, helper) {
        helper.query(component, component.get("v.soql"), "results");            
        helper.describe(component, component.get("v.objectType"), "describe"); 
        component.set("v.masterFilterObject", {});
    },
    
    buildFilters : function (component, event, helper){        
        
		//parallel check        
        if (
            $A.util.isUndefinedOrNull(component.get("v.results"))
        	|| $A.util.isUndefinedOrNull(component.get("v.describe"))
            || typeof _ === 'undefined'
        ) {
            return;
        }
        
        var results = component.get("v.results");
        var describe = component.get("v.describe");
        component.set("v.filteredResults", results);

        
        //build a masterDescribe "API_Name" : {describe for that field} 
        var masterDescribe = {};        
        _.forEach(results, function(r) {            
            _.forEach(r, function(n, key) {                
                masterDescribe[key] = _.find(describe, {"name" : key});
			});
		});		
        console.log(masterDescribe);
        component.set("v.masterDescribe", masterDescribe);

        
        //filters stuff, but first check to see if necessary
        if (component.get("v.filters")==null || component.get("v.filters")=="") {
            //console.log("no filters");
	        component.set("v.filteredResults", results);
            return;            
        }
        
        //console.log('building filters');
        
        var filterObjects = [];
        
        //turn the filters input into an object
        var filterNameArray = component.get("v.filters").replace(/\s+/, "") .split(",");
        for (var x=0; x<filterNameArray.length; x++){
            var value = filterNameArray[x];
            //unique list of options cmp
            var uniqueOptions = _.sortBy(_.compact(_.uniq(_.pluck(results, value))));
            uniqueOptions.unshift('');
            filterObjects.push({
                "field" : value,
                "label" : masterDescribe[value].label,
                "options" : uniqueOptions,
                "value" : ""
            });
        }
        component.set("v.filterObjects" , filterObjects);
        
        
    },
    
    filterChange : function (component, event, helper){
        var refId = event.target.id;
        //console.log("filter changed : " + refId);

        var value = document.getElementById(refId).value;
        var field = refId.replace('Filter', '');
        
        //update the master filter object
        var masterFilterObject = component.get("v.masterFilterObject");
        if (value){
            masterFilterObject[field] = value;
        } else {
            delete masterFilterObject[field];
        }
        component.set("v.masterFilterObject", masterFilterObject);
        
        console.log(masterFilterObject);
        //for each object on the master filter, filter the results to filtered results
        var filteredResults = _.filter(component.get("v.results"), masterFilterObject);
        console.log(filteredResults);
        component.set("v.filteredResults", filteredResults)
		
    }
    
})