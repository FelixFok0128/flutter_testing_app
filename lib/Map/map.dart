import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart'; // ignore: unnecessary_import
import 'package:flutter_testing_app/Map/socket_client.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import 'page.dart';

const randomMarkerNum = 100;

class CustomMarkerPage extends ExamplePage {
  CustomMarkerPage() : super(const Icon(Icons.place), 'Custom marker');

  @override
  Widget build(BuildContext context) {
    return CustomMarker();
  }
}

class CustomMarker extends StatefulWidget {
  const CustomMarker();

  @override
  State createState() => CustomMarkerState();
}

class CustomMarkerState extends State<CustomMarker> {
  final Random _rnd = new Random();

  late MapboxMapController _mapController;
  List<Marker> _markers = [];
  List<_MarkerState> _markerStates = [];
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;

  final GlobalKey screenCapGlobalKey = GlobalKey();

  List<taxiLocation> allTaxi = [];
  // String  selfId =  Random().nextInt(20000).toString();
  int rng = 31;

  // LatLng currentLatlng = LatLng(22.37530980321865, 114.12000278241096);

  void _addMarkerStates(_MarkerState markerState) {
    _markerStates.add(markerState);
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    controller.addListener(() {
      if (controller.isCameraMoving) {
        _updateMarkerPosition();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _getUserLocation();
    super.initState();
  }

  void _onStyleLoadedCallback() {
    print('onStyleLoadedCallback');
  }

  void _onMapLongClickCallback(Point<double> point, LatLng coordinates) {
    _addMarker(point, coordinates);
  }

  void _onCameraIdleCallback() {
    _updateMarkerPosition();
  }

  void _updateMarkerPosition() {
    final coordinates = <LatLng>[];

    for (final markerState in _markerStates) {
      coordinates.add(markerState.getCoordinate());
    }

    _mapController.toScreenLocationBatch(coordinates).then((points) {
      _markerStates.asMap().forEach((i, value) {
        _markerStates[i].updatePosition(points[i]);
      });
    });
  }

  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _locationData = await location.getLocation();
    setState(() {
      _userLocation = _locationData;
    });
  }

  void _addMarker(Point<double> point, LatLng coordinates) {
    setState(() {
      _markers.add(Marker(_rnd.nextInt(100000).toString(), coordinates, point,
          _addMarkerStates));
    });
  }

  @override
  Widget build(BuildContext context) {
    LatLng aLatLong = LatLng(22.37530980321865, 114.12000278241096);
    if (_userLocation != null) {
      aLatLong = LatLng(_userLocation!.latitude!, _userLocation!.longitude!);
    }
    return RepaintBoundary(
        key: screenCapGlobalKey,
        child: Scaffold(
            body: Stack(children: [
              MapboxMap(
                accessToken: FirstScreen.ACCESS_TOKEN,
                trackCameraPosition: true,
                onMapCreated: _onMapCreated,
                onMapLongClick: _onMapLongClickCallback,
                onCameraIdle: _onCameraIdleCallback,
                onStyleLoadedCallback: _onStyleLoadedCallback,
                myLocationEnabled: true,
                initialCameraPosition:
                    CameraPosition(target: aLatLong, zoom: 15),
                myLocationTrackingMode: MyLocationTrackingMode.Tracking,
              ),
              IgnorePointer(
                  ignoring: true,
                  child: Stack(
                    children: _markers,
                  ))
            ]),
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    print("navigation");
                    _printPngBytes();
                  },
                  child: Icon(Icons.navigation_outlined),
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  onPressed: () {
                    // socketListener();
                    Map dumData = {
                      "location": [
                        ["15arv87jhytew", 22.255138, 114.235484, "ISLANDS"],
                        ["sd4563ertru", 22.314948, 114.257284, "SAI KUNG"],
                        ["31", 22.3071517, 114.2230183, "KWUN TONG"],
                        ["11", 22.34, 114.179, "KOWLOON CITY"],
                        ["12", 22.8, 114.379, "Out of Hong Kong"],
                        ["66gerg7", 22.421945, 114.249284, "TAI PO"],
                        ["63", 37.4219884, -122.0840727, "Out of Hong Kong"],
                        ["15", 22.34, 114.179, " KOWLOON CITY"],
                        ["sd", 22.445, 114.5788, "Out of Hong Kong"]
                      ]
                    };

                    getMarker(dumData["location"]);
                  },
                  child: Icon(Icons.pin_drop_outlined),
                ),
              ],
            )));
  }

  void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    print(msg);
  }

// MARK: socket
  void socketListener() async {
    String ipString = "10.88.18.106";
    int portInt = 8888;

    toast("socketListener start connect to $ipString:$portInt");
    final socket = await Socket.connect(ipString, portInt);
    toast(
        "socketListener Connected to ${socket.remoteAddress.address}:${socket.remotePort}");

    // listen to the received data event stream
    socket.listen((List<int> event) {
      var data = utf8.decode(event);
      final jsonData = json.decode(data);
      // print(data.runtimeType );
      // print(data );
      print("socketListener listen $jsonData");
      // print(jsonData.runtimeType);

      if (jsonData is List) {
        //Do something
        // for (var i in jsonData) {
        //   var d = json.decode(i);
        //   print(d);
        // }
        // Map jsonMap = jsonData;

        // jsonMap[]
      } else {
        var clientID = jsonData['clientID'];
        if (clientID != null) {
          updateLocation(clientID, socket);
        }

        getMarker(jsonData);
      }
    });

    // wait 5 seconds..
    await Future.delayed(Duration(seconds: 5));

    // .. and close the socket
    socket.close();
    print("socketListener socket close");
  }

  void updateLocation(clientID, Socket socket) {
    var body =
        '{"type": "Taxi","clientID":${clientID},"lat": ${_userLocation!.latitude},"lng":${_userLocation!.longitude}, "Id": ${rng.toString()}}';
    print("socketListener update $body");

    socket.write(body);
  }

// MARK: - marker
  void getMarker(locationJson) {
    var param = <LatLng>[];
    if (locationJson != null) {
      for (List item in locationJson) {
        if (item[0] != rng.toString()) {
          param.add(LatLng(item[1], item[2]));
        }
      }
      showMarker(param);
      print("socketListener $param");
    }
  }

  void showMarker(List<LatLng> latLngList) {
    _markers.clear();
    _mapController.toScreenLocationBatch(latLngList).then((value) {
      for (var i = 0; i < latLngList.length; i++) {
        var point = Point<double>(value[i].x as double, value[i].y as double);
        _addMarker(point, latLngList[i]);
      }
    });
  }

  //MARK:- cap screen
  Future<Uint8List?> _capturePng() async {
    RenderRepaintBoundary boundary = screenCapGlobalKey.currentContext!
        .findRenderObject()! as RenderRepaintBoundary;

    if (boundary.debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
      return _capturePng();
    }

    var image = await boundary.toImage();
    var byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  void _printPngBytes() async {
    var pngBytes = await _capturePng();
    var bs64 = base64Encode(pngBytes!);

    _createFileFromString(pngBytes);
  }

  Future<String> _createFileFromString(Uint8List imgbytes) async {
    // final encodedStr = imgbytes;
    // print(encodedStr.length);
    // Uint8List bytes = base64.decode(encodedStr);
    print(imgbytes.length);
    String dir = (await getApplicationDocumentsDirectory()).path;
    // File file = File("/storage/emulated/0/Download/" +
    File file =
        File(dir + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
    await file.writeAsBytes(imgbytes);
    print(file.path);
    return file.path;
  }
}

class taxiLocation {
  final String id;
  final String lat;
  final String lng;
  final String location;
  taxiLocation({
    required this.id,
    required this.lat,
    required this.lng,
    required this.location,
  });

  taxiLocation copyWith({
    String? id,
    String? lat,
    String? lng,
    String? location,
  }) {
    return taxiLocation(
      id: id ?? this.id,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      location: location ?? this.location,
    );
  }
}

class Marker extends StatefulWidget {
  final Point _initialPosition;
  final LatLng _coordinate;
  final void Function(_MarkerState) _addMarkerState;

  Marker(
      String key, this._coordinate, this._initialPosition, this._addMarkerState)
      : super(key: Key(key));

  @override
  State<StatefulWidget> createState() {
    final state = _MarkerState(_initialPosition);
    _addMarkerState(state);
    return state;
  }
}

class _MarkerState extends State with TickerProviderStateMixin {
  final _iconSize = 20.0;

  Point _position;

  late AnimationController _controller;
  late Animation<double> _animation;

  _MarkerState(this._position);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var ratio = 1.0;

    //web does not support Platform._operatingSystem
    if (!kIsWeb) {
      // iOS returns logical pixel while Android returns screen pixel
      ratio = Platform.isIOS ? 1.0 : MediaQuery.of(context).devicePixelRatio;
    }

    return Positioned(
        left: _position.x / ratio - _iconSize / 2,
        top: _position.y / ratio - _iconSize / 2,
        child: RotationTransition(
            turns: _animation, child: Icon(Icons.directions_car)
            // Image.asset('assets/symbols/2.0x/custom-icon.png',
            //     height: _iconSize)
            ));
  }

  void updatePosition(Point<num> point) {
    setState(() {
      _position = point;
    });
  }

  LatLng getCoordinate() {
    return (widget as Marker)._coordinate;
  }
}
