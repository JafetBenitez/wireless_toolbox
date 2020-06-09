import 'package:ping_discover_network/ping_discover_network.dart';

class DeviceItem {
  NetworkAddress address;
  List<int> ports = [];

  DeviceItem({this.address, this.ports});


}