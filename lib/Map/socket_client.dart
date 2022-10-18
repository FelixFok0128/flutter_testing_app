import 'dart:io';
import 'dart:convert';
import 'dart:async';

Future<void> main() async {
  String ipString = "10.88.18.106";
  int portInt = 8888;

  final socket = await Socket.connect(ipString, portInt);
  print('Connected to ${socket.remoteAddress.address}:${socket.remotePort}');

  // listen to the received data event stream
  socket.listen((List<int> event) {
    var data = utf8.decode(event);
    final jsonData = json.decode(data);
    // print(data.runtimeType );
    // print(data );
    print(jsonData);
    // print(jsonData.runtimeType);
    if (jsonData is List) {
      //Do something
      for (var i in jsonData) {
        var d = json.decode(i);
        print(d);
      }
    } else {
      var clientID = jsonData['clientID'];
      print("myClientID is " + clientID.toString());
      updateLocation(clientID, socket);
    }
  });

  // // send hello
  // socket.add(utf8.encode('hello'));

  // wait 5 seconds
  await Future.delayed(Duration(seconds: 5));

  // .. and close the socket
  socket.close();
}

void updateLocation(clientID, socket) {
  var body =
      '{"type": "location","clientID":${clientID},"lat": 1233,"lng":1233}';
  socket.write(body);
}
