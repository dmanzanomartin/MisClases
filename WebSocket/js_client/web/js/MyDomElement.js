class MyDomElement{
    constructor(tagName="", attrs=[], childs=[],textContent=undefined, listeners=[]){
        let dom_el = document.createElement(tagName);
        attrs.forEach(att=>{
            if(att!=undefined){
                dom_el.setAttribute(att[0], att[1]);
            }
        });
        if(textContent!=undefined){
            dom_el.innerText=textContent;
        }
        listeners.forEach(l=>{
            dom_el.addEventListener(l[0], e=>{l[1](e)});
        });
        childs.forEach(c=>{
            if(c!=undefined){
                dom_el.appendChild(c);
            }
        });
        return dom_el;
    }
}