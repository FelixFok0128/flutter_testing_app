import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class TestScreen extends StatefulWidget {
  TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final GlobalKey genKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List?> _capturePng() async {
    RenderRepaintBoundary boundary =
        genKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;

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
    // var saveResult = await GallerySaver.saveImage(path);
  }

  Future<String> _createFileFromString(Uint8List imgbytes) async {
    // final encodedStr = imgbytes;
    // print(encodedStr.length);
    // Uint8List bytes = base64.decode(encodedStr);
    print(imgbytes.length);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file =
        File(dir + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
    await file.writeAsBytes(imgbytes);
    print(file.path);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: SingleChildScrollView(
      child: RepaintBoundary(
        key: genKey,
        child: Center(
            child: Column(
          children: "ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ"
              .split("")
              //每一个字母都用一个Text显示,字体为原来的两倍
              .map((c) => OutlinedButton(
                    child: Text(
                      c,
                      textScaleFactor: 2.0,
                    ),
                    onPressed: _printPngBytes,
                  ))
              .toList(),
        )),
      ),
    ));
  }
}
