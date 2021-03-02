class CSVParser(){

	data = [];
    
    get readFromFile(file, hasHeaders = true, separator = ";"){
	    let reader = new FileReader();
        let tagNames = [];
        reader.onload = function(progress){
        	var lines = this.result.split("\n");
            for(let k=0; k<=lines.length-1;k++){
            	if(!hasHeaders){
                	data.push(lines[k].split(separator));
                } else{
                	if(k==0){
                    	tagNames.push(lines[k].split(separator));
                    } else{
                    	let els = lines[k].split(separator);
                        let newObjt = [];
                    	for(int i=0;i<=els.lenght-1;i++){
                        	newObjt.push(tagNames[i]) = els[i];
                        }
                        data.push(newObj);
                    }
                }
            }
        }
        try{
        	reader.readAsText(file);
        } catch e{
        	return e;
        }
        return data;
    }

}
