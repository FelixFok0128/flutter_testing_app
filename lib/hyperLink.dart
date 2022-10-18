import 'package:common_utils/common_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(hyperLinkScreen());
}

class hyperLinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hyperlink Text Example',
      routes: {
        '/': (context) => FirstScreen(),
        '/second': (context) => SecondScreen()
      },
    );
  }
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Hyperlink Text Using Link Widget'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Link(
                  uri: Uri.parse('https://www.google.com'),
                  //target: LinkTarget.self,
                  builder: (context, followLink) {
                    return RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Click here: ',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'AndroidRide',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = followLink,
                        ),
                      ]),
                    );
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Link(
//when taps the link, moves to second screen.
              uri: Uri.parse('/second'),
              builder: (context, followLink) {
                return InkWell(
                  onTap: followLink,
                  child: Text(
                    'Go to Second Screen',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _getContentSpan(String text) {
    List<InlineSpan> _contentList = [];

    RegExp exp =
        //new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
        new RegExp(
            r'(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?');
    // text = "如果www.baidu.com这是一段文本但是里面包含了连接";
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    int index = 0;
    matches.forEach((match) {
      /// start 0  end 8
      /// start 10 end 12
      String c = text.substring(match.start, match.end);

      // print('---地址-url:--$c');
      if (match.start == index) {
        index = match.end;
      }
      if (index < match.start) {
        String a = text.substring(index + 1, match.start);
        // print('---地址-内容AAAA--$a');
        index = match.end;
        _contentList.add(
          TextSpan(text: a),
        );
      }

      if (RegexUtil.isURL(c)) {
        _contentList.add(TextSpan(
            text: c,
            style: TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                var url = text;
                launchUrlString(url);
                // Get.to(WebViewExample(
                //   url: text.substring(match.start, match.end),
                // ));
              }));
      } else {
        _contentList.add(
          TextSpan(text: c),
        );
      }
    });
    if (index < text.length) {
      String a = text.substring(index, text.length);
      // print('---地址-内容BBBB--$a');
      _contentList.add(
        TextSpan(text: a),
      );
    }
    return _contentList;
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
//poping the current screen from the stack, Shows First Screen.
            Navigator.pop(context);
          },
          child: Text('Go Back To First Screen'),
        ),
      ),
    );
  }
}


/*
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(hyperLinkScreen());
}

class hyperLinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hyperlink text example 2'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: RichText(
              text: TextSpan(
                  text: "Hyperlink Example Using RichText & url_launcher",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      var url = 'https://www.google.com';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }),
            ),
          ),
        ),
      ),
    );
  }
}
*/