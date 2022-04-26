var ws;
var messages_div;
var username_input;
var client_input;
var message_input;

const server_url = "localhost";

const get_message = () => {
    return message_input.value;
}

const get_username = () => {
    return username_input.value;
}

const get_client = () => {
    return client_input.value;
}

function add_new_mesage(msg="", is_client=false) {
    messages_div.appendChild(
        new MyDomElement("div", [["class", "positioned"]],
            [
                new MyDomElement("div", [["class", `message ${is_client ? "client" : ""}`]], [], msg)
            ]
        )
    );
}

window.addEventListener("load", () => {
    messages_div = document.getElementById("message_container");
    username_input = document.getElementById("username_input");
    client_input = document.getElementById("client_input");
    message_input = document.getElementById("message_input");
    document.getElementById("access").addEventListener("click",()=>{
        start_server();
        document.getElementById("primary_info").classList.add("hidded");
    })

    document.getElementById("send_button").addEventListener("click", () => {
        let data = JSON.stringify({ "username": get_username(), "client": get_client(), "text": get_message()});
        ws.send(data);
        add_new_mesage(get_message(),false);
        message_input.value = "";
    })

    document.querySelectorAll("input").forEach(i=>{
        i.addEventListener("keyup", k=>{
            if(k.key=="Enter"){
                let el = k.target;
                while(!el.classList.contains("auto_keypress")){
                    el=el.parentNode;
                }
                el.querySelector(".btn_target").click();
            }
        })
    })

})

function start_server() {
    console.log(server_url);
    ws = new WebSocket(`ws://${server_url}:8001`)
    ws.onopen = ()=>{
        ws.send(JSON.stringify({"username":get_username()}));
    }
    ws.addEventListener("message", e => {
        e = e.data;
        add_new_mesage(e, true)
    })
}