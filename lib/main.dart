import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_testing_app/carousel_slider.dart';
import 'package:flutter_testing_app/chat.dart';
import 'package:flutter_testing_app/health.dart';
import 'package:flutter_testing_app/horizontal_list.dart';
import 'package:flutter_testing_app/setstate.dart';
import 'package:flutter_testing_app/test.dart';
import 'package:url_launcher/link.dart';
import 'Map/map.dart';
import 'hyperLink.dart';

import 'package:testing_package/testing_package.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

// import 'dart:io' as io;

void main() {
  runApp(MyAppScreen());
  logger.w("PrettyPrinter warning message");
  logger.e("PrettyPrinter error message");
  logger.d("PrettyPrinter debug message");
  logger.i("PrettyPrinter info message");
  // demo();
}

class MyAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Example',
      routes: {
        '/': (context) => FirstScreen(),
        '/health': (context) => HealthApp(),
        '/hyperlink': (context) => hyperLinkScreen(),
        '/CarouselDemo': (context) => CarouselDemo(),
        '/HorizontalList': (context) => HorizontalList(),
        '/setStateScreen': (context) => setStateScreen(),
        '/map': (context) => CustomMarkerPage(),
        '/chat': (context) => ChatScreen(),
      },
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}

var logger = Logger(
    printer: PrettyPrinter(
        methodCount: 0,
        // errorMethodCount: 5,
        lineLength: 50,
        colors: true,
        printEmojis: true,
        printTime: true));

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);
void demo() {
  logger.d('Log message with 2 methods');

  loggerNoStack.i('Info message');

  loggerNoStack.w('Just a warning!', "Waring");

  logger.e('Error! Something bad happened', 'Test Error');

  loggerNoStack.v({'key': 5, 'value': 'something'});

  Logger(printer: SimplePrinter(colors: true)).v('boom');
}

// class AppStateNotifier extends ChangeNotifier {
//   //
//   bool isDarkMode = false;

//   void updateTheme(bool isDarkMode) {
//     this.isDarkMode = isDarkMode;
//     notifyListeners();
//   }
// }

class FirstScreen extends StatefulWidget {
  // FIXME: You need to pass in your access token via the command line argument
  // --dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE
  // It is also possible to pass it in while running the app via an IDE by
  // passing the same args there.
  //
  // Alternatively you can replace `String.fromEnvironment("ACCESS_TOKEN")`
  // in the following line with your access token directly.
  // static const String ACCESS_TOKEN = String.fromEnvironment("ACCESS_TOKEN");
  static const String ACCESS_TOKEN =
      "pk.eyJ1IjoiZmVsaXhmb2tkaCIsImEiOiJjbDhsZ29vZDIwcWZhM29sNXc3OW11aTZvIn0.IacBVZC9djerJ8CeCZanbQ";

  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
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
              child: getLink('/health', "health"),
            ),
            const SizedBox(
              height: 20,
            ),
            getLink('/map', "map"),
            SizedBox(
              height: 20,
            ),
            getLink('/chat', "chat"),
            const SizedBox(
              height: 20,
            ),
            testingBtn(
                child: Text("Click me"),
                onPressed: () {
                  String aS = testFunction.returnAString("hello world");
                  print(aS);
                  // testFunction func = testFunction();
                  // testFunction.returnAString;
                }),
            SizedBox(
              height: 20,
            ),
            OutlinedButton(
                onPressed: () {
                  Get.changeThemeMode(
                      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
                },
                child: const Text.rich(
                  TextSpan(children: [
                    TextSpan(text: "Home: "),
                    TextSpan(
                        text: "https://flutterchina.club",
                        style: TextStyle(color: Colors.blue),
                        recognizer: null),
                  ]),
                )),
          ],
        ),
      ),
    );
  }

  Widget getLink(String uriString, String title) {
    return Link(
      uri: Uri.parse(uriString),
      builder: (context, followLink) {
        return InkWell(
            onTap: followLink,
            child: Text('Go to $title Screen',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                )));
      },
    );
  }
}
