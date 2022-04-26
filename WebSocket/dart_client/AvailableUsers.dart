// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/pages/Chat/ChatPage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AvailableUsers extends StatefulWidget {
  final Map<String, dynamic> info;
  const AvailableUsers({Key? key, required this.info}) : super(key: key);

  @override
  State<AvailableUsers> createState() => _AvailableUsersState();
}

class _AvailableUsersState extends State<AvailableUsers> {
  late WebSocketChannel ws;
  late Stream stream;
  late StreamSubscription<dynamic> list;
  List<dynamic> clients = [];

  void start_server() {
    ws = IOWebSocketChannel.connect(Uri.parse("ws://${server}:${port}"));
    stream = ws.stream.asBroadcastStream();

    ws.sink.add(jsonEncode({"username": widget.info["username"]}));

    list = stream.listen((d) {
      setState(() {
        clients=jsonDecode(d);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    start_server();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios disponibles"),
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
          itemCount: clients.length,
          itemBuilder: (cntx, i) {
            if(widget.info["username"]==clients[i]){
              return const Text("");
            }
            return GestureDetector(
              onTap: () {
                widget.info["client"] = clients[i];
                list.cancel();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => ChatPage(
                      ws: ws,
                      data: widget.info,
                      stream: stream,
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Text("${clients[i]}"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
