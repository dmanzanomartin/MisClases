import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/pages/Chat/AvailableUsers.dart';
import 'package:my_app/pages/Chat/ChatPage.dart';

const double padding = 20;
Map<String, Object> info = {};

class InfoChat extends StatefulWidget {
  InfoChat({Key? key}) : super(key: key);

  @override
  State<InfoChat> createState() => _InfoChatState();
}

class _InfoChatState extends State<InfoChat> {
  TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            color: Colors.blue[700],
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                height: height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: padding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyInput(
                          hint: "Introduce tu nombre",
                          controller: usernameController),
                      ChatAccess(
                        usernameController: usernameController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyInput extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  MyInput({Key? key, required this.hint, required this.controller})
      : super(key: key);

  @override
  State<MyInput> createState() => _MyInputState();
}

class _MyInputState extends State<MyInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // ignore: prefer_const_constructors
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        obscureText: false,
        //style: TextStyle(color: Colors.blue),
        controller: widget.controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: InputBorder.none,
          hintText: widget.hint,
        ),
      ),
    );
  }
}

class ChatAccess extends StatefulWidget {
  final TextEditingController usernameController;
  ChatAccess({
    Key? key,
    required this.usernameController,
  }) : super(key: key);

  @override
  State<ChatAccess> createState() => _ChatAccessState();
}

class _ChatAccessState extends State<ChatAccess> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              onPressed: () {
                info["username"] = widget.usernameController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AvailableUsers(
                      info: info,
                    ),
                  ),
                );
                //Navigator.push(context, MaterialPageRoute(builder: (c)=>MainPage()));
              },
              child: const Text(
                "Accede a la sala",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
