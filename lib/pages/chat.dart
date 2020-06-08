import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//plugins
import 'package:firebase_auth/firebase_auth.dart';
import 'package:venus/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//pages
import 'package:venus/pages/welcome.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class Chat extends StatefulWidget {
  static String id = 'chat';
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, Welcome.id, (Route<dynamic> route) => false);
              }),
        ],
        title: Text(
          'eChat',
        ),
        backgroundColor: Color.fromRGBO(112, 189, 165, 1),
        elevation: 0.0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      color: Color.fromRGBO(112, 189, 165, 1),
                      onPressed: () {
                        messageTextController.clear();
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': loggedInUser.email,
                          'sent': DateTime.now(),
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('messages')
          .orderBy('sent', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color.fromRGBO(74, 210, 149, 0.5),
            ),
          );
        }
        final messages = snapshot.data.documents;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];
          final messageSent = message.data['sent'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            sent: messageSent,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.sender, this.sent, this.isMe});
  final String text;
  final String sender;
  final Timestamp sent;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Color.fromRGBO(74, 210, 149, 0.5) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    sender,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: isMe ? Colors.amberAccent : Colors.lightBlueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 6.0)),
                  Text(
                    text,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(6.0)),
          Text(
            sent.toDate().toString(),
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
