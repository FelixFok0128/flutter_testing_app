import 'dart:math';

import 'package:flutter/material.dart';
import 'package:talkjs_flutter/talkjs_flutter.dart';

void main() {
  runApp(const ChatScreen());
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // We're using this variable as our state
  // It's initialized to false, to show a placeholder widget
  // while the ChatBox is loading
  bool chatBoxVisible = false;

  @override
  Widget build(BuildContext context) {
    final session = Session(appId: 'twXs1hrO');

    final me = session.getUser(id: '123456', name: 'Alice', role: 'tester');
    // final me = session.getUser(id: '654321', name: 'Sebastian', role: 'tester');
    session.me = me;
    // final other = session.getUser(id: '654321', name: 'Sebastian');
    // // final other = session.getUser(id: '123456', name: 'Alice');

    final other = session.getUser(id: '654321', name: 'Sebastian');
    final other2 = session.getUser(id: 'qwerty', name: 'Bobby');
    final conversation = session.getConversation(
      id: Talk.oneOnOneId(me.id, other.id),
      participants: {Participant(me), Participant(other)},
    );

    return MaterialApp(
      title: 'TalkJS Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test TalkJS'),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) => Column(
            children: <Widget>[
              // We use Visibility to show or hide the widgets
              Visibility(
                visible:
                    !chatBoxVisible, // Shown when the ChatBox is not visible
                child: SizedBox(
                  width: min(constraints.maxWidth, constraints.maxHeight),
                  height: min(constraints.maxWidth, constraints.maxHeight),
                  // Using CircularProgressIndicator as an example placeholder
                  // while the ChatBox is loading
                  child: CircularProgressIndicator(),
                ),
              ),
              Visibility(
                maintainState:
                    true, // It is important to set maintainState to true,
                // or else the ChatBox will not load
                visible: chatBoxVisible, // Shown when the ChatBox is visible
                child: ConstrainedBox(
                  constraints:
                      constraints, // We need to constrain the size of the widget,
                  // because the widget must have a valid size,
                  // even when it is not shown
                  child: ChatBox(
                    session: session,
                    conversation: conversation,
                    onLoadingStateChanged: (state) {
                      // This is the important part:
                      // We're calling setState to force rebuilding the widget tree,
                      // and we set the visibility of the ChatBox according to its loading state
                      setState(() {
                        if (state == LoadingState.loaded) {
                          chatBoxVisible = true;
                        } else {
                          chatBoxVisible = false;
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
