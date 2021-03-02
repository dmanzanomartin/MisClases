class CSVParser{

    constructor (){}
    
    /**
     * 
     * @param {File} file - File to be readed
     * @param {Boolean} hasHeaders - True or false depending if the file has headers
     * @param {String} separator - String to define the type of separator
     */
    readFromFile(file, hasHeaders = false, separator = ";"){
	    return new Promise((resolve, reject)=>{
            let reader = new FileReader();
            let headers = new Array();
            let returnData = new Array();
            returnData["data"] = new Array();
            reader.onload = function(progress){
            	var lines = this.result.split("\n");
                for(let k=0; k<=lines.length-1;k++){
                	if(!hasHeaders){
                    	returnData["data"].push(lines[k].split(separator));
                    } else{
                    	if(k==0){
                        	headers.push(lines[k].split(separator));
                        } else{
                        	let els = lines[k].split(separator);
                            let newObjt = [];
                        	for(let i=0;i<=els.length-1;i++){
                            	newObjt[headers[0][i]] = els[i];
                            }
                            returnData["data"].push(newObjt);
                        }
                    }
                }
                if(hasHeaders){
                    returnData["headers"] = headers[0];
                }
                resolve(returnData);
            }
            try{
            	reader.readAsText(file);
                return returnData;
            } catch (e){
            	return new Array();
            }
        })
    }

}