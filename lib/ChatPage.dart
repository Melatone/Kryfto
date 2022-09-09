import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/scroll_controller.dart';
import 'package:kryfto/Model/Message.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'Model/User.dart';

class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  TextEditingController msgInputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  late IO.Socket socket;

  @override
  void initState() {
    // TODO: implement initState
    socket = IO.io(
        "http://10.0.2.2:5000",
        IO.OptionBuilder()
            .setQuery({'chatID': widget.user.username})
            .setTransports(["websocket"])
            .disableAutoConnect()
            .build());

    socket.on('chat message', (msg) {
      Map<String, dynamic> data = json.decode(msg);
      this.setState(() {
        messages.add(Message(data['text'], data['senderUsername'],
            data['receiverUsername'], false));
      });
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.ease,
      );
    });

    super.initState();
    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [
          Expanded(
              flex: 9,
              child: Container(
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == messages.length)
                        return Container(
                          height: 40,
                        );
                      var currentMSG = messages[index];
                      return MessageItem(
                        sentByme: currentMSG.sendbyme,
                        MSG: currentMSG.sendbyme
                            ? currentMSG.text
                            : "${currentMSG.senderUsername}: ${currentMSG.text}",
                      );
                    }),
              )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(10),
            color: Colors.red,
            child: TextField(
              cursorColor: Colors.purple,
              controller: msgInputController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: IconButton(
                      onPressed: () {
                        sendMessage(msgInputController.text, "peek");
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
          )),
        ]),
      ),
    );
  }

  void sendMessage(String text, String receiverUsername) {
    this.setState(() {
      messages.add(Message(text, widget.user.username, receiverUsername, true));
    });

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 600),
      curve: Curves.ease,
    );
    socket.emit(
        'chat message',
        json.encode({
          'senderUsername': widget.user.username,
          'receiverUsername': receiverUsername,
          'text': text
        }));
    msgInputController.clear();
  }
}

class MessageItem extends StatelessWidget {
  const MessageItem({Key? key, required this.sentByme, required this.MSG})
      : super(key: key);
  final bool sentByme;
  final String MSG;
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: sentByme ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text(
                  MSG,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  width: 5,
                )
              ],
            )));
  }
}
