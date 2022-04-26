// ignore_for_file: unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const double padding = 20;

const server = "localhost";
const port = 8001;

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final Stream stream;
  final WebSocketChannel ws;
  const ChatPage({
    Key? key,
    required this.data,
    required this.stream,
    required this.ws,
  }) : super(key: key);

  //const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isServerStarted = false;
  List messages = [];

  void start_listener() {
    widget.stream.listen((d) {
      setState(() {
        messages.add({"msg": d, "isMine": false});
      });
    });
  }

  @override
  void initState() {
    super.initState();
    start_listener();
  }

  final String client = "asddsa";
  final TextEditingController msgController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.backspace),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Colors.blue[700],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: messages.length,
          itemBuilder: (cntx, i) {
            Map<String, dynamic> msg = messages[i];
            return Message(msg: msg);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          children: [
            Expanded(
                child: MyInput(
              controller: msgController,
              hint: 'Mensaje a enviar',
              icon: IconButton(
                onPressed: () {
                  widget.ws.sink.add(jsonEncode({
                    "username": widget.data["username"],
                    "client": widget.data["client"],
                    "text": msgController.text
                  }));
                  setState(() {
                    messages.add({"msg": msgController.text, "isMine": true});
                    msgController.text = "";
                  });
                },
                icon: const Icon(
                  Icons.send,
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  final Map<String, dynamic> msg;
  const Message({
    Key? key,
    required this.msg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment:
          (msg["isMine"]) ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
              bottomRight:
                  (msg["isMine"]) ? Radius.zero : const Radius.circular(10),
              bottomLeft:
                  (msg["isMine"]) ? const Radius.circular(10) : Radius.zero,
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: width * .8),
              color: Colors.green[300],
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(msg["msg"]),
            ),
          ),
        ),
      ],
    );
  }
}

class MyInput extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final IconButton icon;

  const MyInput(
      {Key? key,
      required this.hint,
      required this.controller,
      required this.icon})
      : super(key: key);

  @override
  State<MyInput> createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      // ignore: prefer_const_constructors
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        obscureText: false,
        //style: TextStyle(color: Colors.blue),
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: widget.icon,
          fillColor: Colors.white,
          filled: true,
          border: InputBorder.none,
          hintText: widget.hint,
        ),
      ),
    );
  }
}
