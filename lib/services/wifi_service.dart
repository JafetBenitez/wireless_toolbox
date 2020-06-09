import 'dart:async';
import 'dart:core';

import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:wifi_flutter/wifi_flutter.dart';
import 'package:wireless_toolbox/widgets/device_item.dart';

class WifiService {
  static List<int> ports = [
    21, // TCP port 21 — FTP (File Transfer Protocol)
    22, // TCP port 22 — SSH (Secure Shell)
    23, // TCP port 23 — Telnet
    25, // TCP port 25 — SMTP (Simple Mail Transfer Protocol)
    53, // TCP and UDP port 53 — DNS (Domain Name System)
    443, // TCP port 443 — HTTP (Hypertext Transport Protocol) and HTTPS (HTTP over SSL)
    110, // TCP port 110 — POP3 (Post Office Protocol version 3)
    135, // TCP and UDP port 135 — Windows RPC
    137, // TCP and UDP ports 137–139 — Windows NetBIOS over TCP/IP
    138,
    139,
    1433, // TCP port 1433 and UDP port 1434 — Microsoft SQL Server
    1434,
    5432
  ];

  final StreamController<List<DeviceItem>> _vulnerableDevices =
      StreamController<List<DeviceItem>>();
  
  Stream<List<DeviceItem>> get vulnerableDevices => _vulnerableDevices.stream;

  void scanWithSocket(String subnet,
      {int idx = 0, List<DeviceItem> devices}) async {
    if (devices == null) {
      devices = [];
    }

    final stream = NetworkAnalyzer.discover2(subnet, ports[idx],
        timeout: Duration(seconds: 2));

    await stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        print('Found device: ${addr.ip}:${ports[idx]}');

        var wasAdded = false;

        for (DeviceItem di in devices) {
          if (di.address.ip == addr.ip) {
            di.ports.add(ports[idx]);
            wasAdded = true;
          }
        }

        if (!wasAdded) {
          devices.add(DeviceItem(address: addr, ports: [ports[idx]]));
        }
      }
    }).asFuture();

    idx++;
    if (idx >= ports.length) {
      print('finish');
      _vulnerableDevices.add(devices);
      _vulnerableDevices.close();
      return;
    }
    // await Future.delayed(Duration(milliseconds: 100));

    scanWithSocket(subnet, idx: idx, devices: devices);
  }

   Future<List<WifiNetwork>> scanWifiNetworks() async {
    List<WifiNetwork> result = [];

    // try {

    // bool hasPermissions = await WifiFlutter.promptPermissions();
    // if (!hasPermissions) {
    //   return result;
    // }
    // } catch(error) {
    //   print(error);

    // }

    Iterable<WifiNetwork> wifies = await WifiFlutter.wifiNetworks;

    if (wifies == null) {
      return result;
    }

    result = wifies.toList();

    return result;
  }



  WifiService() {}

}
