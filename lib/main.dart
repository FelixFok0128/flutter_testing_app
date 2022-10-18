import 'package:flutter/material.dart';
import 'package:flutter_testing_app/carousel_slider.dart';
import 'package:flutter_testing_app/health.dart';
import 'package:flutter_testing_app/horizontal_list.dart';
import 'package:flutter_testing_app/setstate.dart';
import 'package:url_launcher/link.dart';
import 'Map/map.dart';
import 'hyperLink.dart';

void main() {
  runApp(MyAppScreen());
}

class MyAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hyperlink Text Example',
      routes: {
        '/': (context) => FirstScreen(),
        '/health': (context) => HealthApp(),
        '/hyperlink': (context) => hyperLinkScreen(),
        '/CarouselDemo': (context) => CarouselDemo(),
        '/HorizontalList': (context) => HorizontalList(),
        '/setStateScreen': (context) => setStateScreen(),
        '/map': (context) => CustomMarkerPage(),
      },
      themeMode: ThemeMode.dark,
    );
  }
}

class FirstScreen extends StatelessWidget {
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
            SizedBox(
              height: 20,
            ),
            getLink('/map', "map"),
            SizedBox(
              height: 20,
            ),
            getLink('/setStateScreen', "setStateScreen"),
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
