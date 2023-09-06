import 'dart:async';

import 'package:dutatani_mapping_iot/bluetooth/DiscoveryPage.dart';
import 'package:dutatani_mapping_iot/bluetooth/SelectBondedDevicePage.dart';
import 'package:dutatani_mapping_iot/bluetooth/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';



class ScanDevice extends StatefulWidget {
  @override
  _ScanDeviceState createState() => _ScanDeviceState();
}

class _ScanDeviceState extends State<ScanDevice> {
BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
String _address ="...";
String _name ="...";

Timer  _discoverableTimeoutTimer;
int _discoverableTimeoutSecondsLeft = 0;

bool _autoAcceptPairingRequest = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();

//masukin state bluetooth
    FlutterBluetoothSerial.instance.state.then((state){
      setState(() {
        _bluetoothState =state;
      });
    });

Future.doWhile(() async{
  //cek adapter 
if(await FlutterBluetoothSerial.instance.isEnabled){
  return false;
}
await Future.delayed(Duration(milliseconds: 0xDD));
return true;
}).then((_){
  //update address
  FlutterBluetoothSerial.instance.address.then((address){
    setState(() {
      _address = address;
    });
  });
  FlutterBluetoothSerial.instance.name.then((name){
    setState(() {
      _name = name;
    });
    FlutterBluetoothSerial.instance.onStateChanged().listen((BluetoothState state){
      setState(() {
        _bluetoothState = state;
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });  
  });
});
}

@override
  void dispose() {
    // TODO: implement dispose
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       theme: ThemeData(
            primaryColor: Colors.green, accentColor: Colors.yellowAccent),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text("BLUETOOTH"),
          ),
          body: Container(
            child: ListView(
              children:<Widget>[
                Divider(),
                ListTile(title: Text("General")),
                SwitchListTile(
                  title:Text("ENABLE BLUETOOTH"),
                  value: _bluetoothState.isEnabled,
                  onChanged: (bool value){
                     future() async { // async lambda seems to not working
                  if (value)
                    await FlutterBluetoothSerial.instance.requestEnable();
                  else
                    await FlutterBluetoothSerial.instance.requestDisable();
                }
                future().then((_) {
                  setState(() {});
                });
                  },
                ),
                ListTile(
                  title: const Text('Bluetooth status'),
                  subtitle: Text(_bluetoothState.toString()),
                  trailing: RaisedButton(
                  child: const Text('Settings'),
                  onPressed: () { 
                      FlutterBluetoothSerial.instance.openSettings();
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Local adapter name'),
                  subtitle: Text(_name),
                  onLongPress: null,
                ),
                ListTile(
                  title: _discoverableTimeoutSecondsLeft == 0 ? const Text("Discoverable") : Text("Discoverable for ${_discoverableTimeoutSecondsLeft}s"),
                  subtitle: const Text("PsychoX-Luna"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:[
                      Checkbox(
                        value: _discoverableTimeoutSecondsLeft !=0,
                        onChanged: null,
                      ),
                      IconButton(icon: Icon(Icons.edit), onPressed: null),
                      IconButton(icon: Icon(Icons.refresh), 
                      onPressed: () async{
                        print("Discoverable requested");
                        final int timeout = await FlutterBluetoothSerial.instance.requestDiscoverable(60);
                        if(timeout < 0){
                           print('Discoverable mode denied');
                        }
                        else {
                        print('Discoverable mode acquired for $timeout seconds');
                        }
                        setState(() {
                           _discoverableTimeoutTimer?.cancel();
                        _discoverableTimeoutSecondsLeft = timeout;
                        _discoverableTimeoutTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
                          setState(() {
                            if(_discoverableTimeoutSecondsLeft < 0){
                              FlutterBluetoothSerial.instance.isDiscoverable.then((isDiscoverable){
                                if(isDiscoverable){
                                   print("Discoverable after timeout... might be infinity timeout :F");
                                  _discoverableTimeoutSecondsLeft += 1;
                                }
                              });
                              timer.cancel();
                              _discoverableTimeoutSecondsLeft = 0;
                            }
                            else{
                              _discoverableTimeoutSecondsLeft -= 1;
                            }
                          });
                        });
                      });

                      })
                    ]
                  )
                ),
                Divider(),
                ListTile(
                  title: const Text('Devices discovery and connection')
                ),
                SwitchListTile(
                  title: Text("Auto Specific pin when pairing"),
                  subtitle: Text("pin 1234"),
                  value: _autoAcceptPairingRequest, 
                  onChanged: (bool value){
                    setState(() {
                      _autoAcceptPairingRequest = value;
                    });
                     if (value) {
                      FlutterBluetoothSerial.instance.setPairingRequestHandler((BluetoothPairingRequest request) {
                      print("Trying to auto-pair with Pin 1234");
                    if (request.pairingVariant == PairingVariant.Pin) {
                      return Future.value("1234");
                    }
                    return null;
                  });
                }
                else {
                  FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
                    }
                  }
                ),
                 ListTile(
                  title: RaisedButton(
                  child: const Text('Explore discovered devices'),
                  onPressed: () async {
                  final BluetoothDevice selectedDevice = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) { return DiscoveryPage(); })
                  );

                  if (selectedDevice != null) {
                    print('Discovery -> selected ' + selectedDevice.address);
                  }
                  else {
                    print('Discovery -> no device selected');
                  }
                }
              ),
            ),
            ListTile(
              title: RaisedButton(
                child: const Text('Connect to paired device to chat'),
                onPressed: () async {
                  final BluetoothDevice selectedDevice = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) { return SelectBondedDevicePage(checkAvailability: false); })
                  );

                  if (selectedDevice != null) {
                    print('Connect -> selected ' + selectedDevice.address);
                    _startChat(context, selectedDevice);
                  }
                  else {
                    print('Connect -> no device selected');
                  }
                },
              ),
            ),

            Divider(),
              ]
            ),
          ),
        )
    );
  }
  
  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) { return ChatPage(server: server); }));
  }

  Future<void> _startBackgroundTask(BuildContext context, BluetoothDevice server) async {

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error occured while connecting'),
            content: Text(""),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
  }

}