import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_testing_app/carousel_slider.dart';
import 'package:flutter_testing_app/chat.dart';
import 'package:flutter_testing_app/health.dart';
import 'package:flutter_testing_app/horizontal_list.dart';
import 'package:flutter_testing_app/setstate.dart';
import 'package:inspector/inspector.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:url_launcher/link.dart';
import 'Map/map.dart';
import 'Map/moveMarker.dart';
import 'hyperLink.dart';

import 'package:flutter_package_spa_util/flutter_package_spa_util.dart';
import 'package:logger/logger.dart';

// import 'dart:io' as io;

void main() {
  runApp(MyAppScreen());
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
        '/map2': (context) => MapboxUI(
              ACCESS_TOKEN: FirstScreen.ACCESS_TOKEN,
            ),
        '/chat': (context) => ChatScreen(),
        '/moveMarker': (context) => moveMarker(),
      },
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      builder: (context, child) => kDebugMode
          ? Inspector(
              child: child!,
              isEnabled: true,
            )
          : child!,
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

void demo() async {
  logger.d('Log message with 2 methods');

  loggerNoStack.i('Info message');

  loggerNoStack.w('Just a warning!', "Waring");

  logger.e('Error! Something bad happened', 'Test Error');

  loggerNoStack.v({'key': 5, 'value': 'something'});

  Logger(printer: SimplePrinter(colors: true)).v('boom');
  // testFunction.returnAString("string");
  // await SharedPreferencesUtil.listKey();
  // String? test1 = await SharedPreferencesUtil.getString("test1");
  // if (test1 == null) {
  //   SharedPreferencesUtil.setString("test1", "test1");
  // } else {
  //   SharedPreferencesUtil.setString("test1", "${DateTime.now()}");
  // }
}

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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int currentIndex = 0;
  final pages = [
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.yellow,
    ),
    Container(
      color: Colors.blue,
    )
  ];
  // String aa = SPAColorSet.PrimaryGradient.color.withOpacity(30).toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print("navigation");
          widget._scaffoldKey.currentState?.openDrawer();
        },
        child: Icon(Icons.navigation_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      drawer: aDrawer(context),
      appBar: anAppBar(),
      // bottomNavigationBar: BottomBar(
      //   onPressed: () {
      //     logger.d("BottomBar");
      //   },
      //   onChange: (int selectedIndex) {
      //     setState(() {
      //       currentIndex = selectedIndex;
      //     });
      //   },
      // ),
      // body: pages[currentIndex],

      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
              // color: Colors.red,
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
              const SizedBox(
                height: 20,
              ),
              getLink('/chat', "Chat"),
              const SizedBox(
                height: 20,
              ),
              // CircleBtn(
              //   btnType: CircleBtnType.notification,
              //   isNotify: true,
              //   onPressed: () {},
              // ),
              TaxiTypeSelector(
                onTap: (TaxiType taxiType) {
                  // logger.d(taxiType, TaxiTypeSelector);
                },
              ),
              // bioAuth(),
              // driverHomeTopBar(),
              // const PassengerDistrictClock(
              //   type: PassengerDistrictClockMode.normal,
              // ),

              // SpecialButton(
              //   icon: Icons.send,
              //   onPressed: () {},
              // ),
              // TaxiTypeButton(
              //     iconPath: "assets/images/blue4taxi.svg",
              //     type: TaxiTypeButtonMode.left,
              //     taxiDesc: "12312312",
              //     onTap: () {}),
              // RoundedSqBtn(),
              // TipsButtonGroup(const [1111, 13, 14, 15]),
              // testingBtn(
              //     child: SPAText.T1Title("我們望是"),
              //     onPressed: () async {}),
              const SizedBox(
                height: 20,
              ),
            ],
          ))),
    );
  }

  // Widget homepageOptionBtn() {
  //   return HomePageOptionButton(
  //     iconPath: "assets/images/blue4taxi.svg",
  //     onItemChange: (List<String> selectedItem) {
  //       logger.d("option btn $selectedItem");
  //     },
  //     title: '_選擇服務',
  //     itemList: ["123", "345", "5656"],
  //   );
  // HomePageOptionButton(
  //   iconPath: "assets/images/blue4taxi.svg",
  //   onItemChange: (List<String> selectedItem) {
  //     logger.d("option btn $selectedItem");
  //   },
  //   title: '_選擇服務',
  //   itemList: [],
  // );
  // }

  // Widget driverHomeTopBar() {
  // DriverIncomeItem item =
  //     DriverIncomeItem("999999999999999999999", "1/1", "99", "4.99");
  // return HomeTopBar(incomeItem: item);
  // }

  Widget getLink(String uriString, String title) {
    return Link(
      uri: Uri.parse(uriString),
      builder: (context, followLink) {
        return InkWell(
            onTap: followLink,
            child: Text('Go to $title Screen',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                )));
      },
    );
  }

  PreferredSizeWidget anAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.green),
      // backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text('Flutter Hyperlink Text Using Link Widget'),
      actions: [
        // Icon(Icons.add)

        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {},
        ),
        // Ink(
        //   decoration: ShapeDecoration(
        //     color: Colors.yellow,
        //     shape: CircleBorder(),
        //   ),
        //   child: IconButton(
        //     icon: Icon(Icons.add),
        //     color: Colors.white,
        //     onPressed: () {},
        //   ),
        // ),
        // TextButton(
        //   style: TextButton.styleFrom(
        //     backgroundColor: Colors.yellow,
        //     shape: CircleBorder(),
        //   ),
        //   child: Icon(
        //     Icons.file_download,
        //     color: Colors.green,
        //   ),
        //   onPressed: () {},
        // ),
        // Container(
        //   child: IconButton(
        //     icon: Icon(
        //       Icons.file_download,
        //       color: Colors.green,
        //     ),
        //     color: Colors.yellow,
        //     onPressed: () {
        //       logger.d("clicked");
        //     },
        //   ),
        //   color: Colors.blue,
        // )
      ],
    );
  }

  Widget bioAuth() {
    return IconButton(
      icon: const Icon(Icons.send),
      onPressed: () async {
        bool authenticated = false;
        try {
          authenticated = await LocalAuthentication().authenticate(
              localizedReason: 'Please authenticate to show account balance',
              options: const AuthenticationOptions(
                  useErrorDialogs: false, biometricOnly: true));
          // ···
        } on PlatformException catch (e) {
          print("bioAuth ${e.code}");
          authenticated = false;
        }
        logger.d(authenticated, "bioAuth");
      },
    );
  }

  Widget aDrawer(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

extension BoolParsing on String {
  bool toBool() {
    if (this.toLowerCase() == 'true') {
      return true;
    } else if (this.toLowerCase() == 'false') {
      return false;
    }

    throw '"$this" can not be parsed to boolean.';
  }
}
