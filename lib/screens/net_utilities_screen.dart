import 'dart:io';

import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:wifi_flutter/wifi_flutter.dart';
import 'package:wireless_toolbox/services/wifi_service.dart';
import 'package:wireless_toolbox/widgets/device_item.dart';


class NetUtilitiesScreen extends StatefulWidget {
  @override
  _NetUtilitiesScreenState createState() => _NetUtilitiesScreenState();
}

class _NetUtilitiesScreenState extends State<NetUtilitiesScreen> {
  String _netName = 'NET_NAME';
  String _ssid = 'WIFI_SSID';
  String _wifiIp = 'WIFI IP';
  List<WifiNetwork> _networks = [];
  List<DeviceItem> _devices = [];
  WifiService _service = WifiService();


  Future _scanWifiNetworks() async {
    List<WifiNetwork> networks = await _service.scanWifiNetworks();
    setState(() {
      _networks = networks;
    });

  }


  Future _refreshData() async {
    print('_refreshData()');
    String netName, ssid, wifiIp;

    try {
      var connect = Connectivity();
      connect.onConnectivityChanged.listen((ConnectivityResult onData) async {
        if (onData == ConnectivityResult.wifi) {
          netName = await connect.getWifiName();
          ssid = await connect.getWifiBSSID();
          wifiIp = await connect.getWifiIP();

          setState(() {
            if (netName != null) {
              _netName = netName;
            }
            if (ssid != null) {
              _ssid = ssid;
            }
            if (wifiIp != null) {
              _wifiIp = wifiIp;
            }
          });

          final String ip = wifiIp;
          final String subnet = ip.substring(0, ip.lastIndexOf('.'));

          _scanWifiNetworks().then( (val) {
            print(val);
          });
          _service.scanWithSocket(subnet);

          _service.vulnerableDevices.listen((devices) {
          setState(() {
            _devices = devices;
          });
        print('******************');
    });
        } 
      });
    } catch (exception) {
      print(exception.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    this._refreshData().then((_) {
      print('_refreshData() - just finished');
    });
  }

  @override
  Widget build(BuildContext context) {

    
    
    return Scaffold(
      appBar: AppBar(title: Text('Wifi'),),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _netName,
                  style: TextStyle(fontSize: 40),
                ),
                Text(
                  'Wifi SSID: $_ssid',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),

                Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Text(
                    'Networks nearby',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Container(
                  height: 150,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap:
                          true, //this property is must when you put List/Grid View inside SingleChildScrollView

                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: 150,
                          child: Card(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon((_networks[index].isSecure
                                      ? Icons.wifi_lock
                                      : Icons.wifi), color: Colors.red),
                                  Text(_networks[index].ssid),
                                  Text("${_networks[index].rssi}")
                                ]),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: _networks.length),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Text(
                    'Vulnerable devices in $_netName',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                Text(
                  'Current IP address: $_wifiIp',
                  style: TextStyle(fontSize: 18),
                ),
                ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(child: Icon(Icons.security)),
                        title: Text(_devices[index].address.ip, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold) ,),
                        subtitle: Text(_devices[index].ports.join(',')),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: _devices.length),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
         await  _refreshData();
        },
        tooltip: 'Get data',
        child: Icon(Icons.network_wifi),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
