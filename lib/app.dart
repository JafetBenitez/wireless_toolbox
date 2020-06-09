
import 'package:flutter/material.dart';
import 'screens/bluetooth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/net_utilities_screen.dart';


class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        NetUtilitiesScreen(),
        HomeScreen(),
        BluetoothScreen()
      ].elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.network_wifi), title: Text('Net')),
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
        BottomNavigationBarItem(icon: Icon(Icons.bluetooth), title: Text('Bluetooth'))
      ],
      onTap: _onBottomItemTap,
            currentIndex: _selectedIndex,
            ),
          );
        }
      
        void _onBottomItemTap(int value) {
          setState(() {
            _selectedIndex = value;
          });
  }
}