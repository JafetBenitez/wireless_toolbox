import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  List<ScanResult> _devices = [];
  void _initBlu() async {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    if (flutterBlue == null) {
      return;
    }
    try {
      // Start scanning
      flutterBlue.startScan(timeout: Duration(seconds: 10));
      flutterBlue.scanResults.listen((results) {
        for (var onData in results) {

          var bluDevice = _devices.firstWhere(
              (d) => onData.device.id.id == d.device.id.id,
              orElse: () => null);

          if (bluDevice == null) {
            setState(() {
              _devices.add(onData);

            });
          }
        }
      });

      // Stop scannings
      flutterBlue.stopScan();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    _initBlu();
    return Scaffold(
      appBar: AppBar(title: Text('Bluetooth'),),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Text(
              'Bluetooth devices',
              style: TextStyle(fontSize: 40),
            ),
            ListView.separated(
              shrinkWrap:
                  true, //this property is must when you put List/Grid View inside SingleChildScrollView
              physics:
                  NeverScrollableScrollPhysics(), //this property is must when you put List/Grid View inside SingleChildScrollView
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(child: Icon(Icons.bluetooth)),
                  title: Text(_devices[index].device.name ??
                      _devices[index].device.id.id),
                  subtitle: Text(_devices[index].device.id.id),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: _devices.length),
              ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _initBlu,
        child: Icon(Icons.bluetooth),
      ),
    );
  }
}
