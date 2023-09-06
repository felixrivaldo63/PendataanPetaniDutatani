import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice server;
  
  const ChatPage({this.server});
  
  @override
  _ChatPage createState() => new _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  String long = "";
  String lati = "";
  String pinNum = "";
  static final clientID = 0;
  static final maxMessageLength = 4096 - 3;
  BluetoothConnection connection;

  String _messageBuffer = '';

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        }
        else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: (
          isConnecting ? Text('Connecting to ' + widget.server.name + '...') :
          isConnected ? Text('Connected with ' + widget.server.name) :
          Text('Disconnected from ' + widget.server.name)
        )
      ),
      body: Center(
          child: isConnecting ? Text('Wait until connected...',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontFamily: "Roboto"
            ),
          ) :
          isConnected ? Column(

              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('$long longit',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Roboto"
                      ),),

                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('$lati Latitude',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Roboto"
                    ),
                    ),

                  ],

                ),
            

              ]
          ): Text('Got disconnected',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontFamily: "Roboto"
            ),)

      )
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      }
      else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        }
        else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);

    if (~index != 0) { // \r\n
      setState(() {
        String received_data = _messageBuffer + dataString.substring(0, index);
        received_data = received_data.trim();
        print(received_data);
//        print(received_data.substring(0, 4));
//        print(received_data.length);
        if (received_data.substring(0, 5) == 'long:'){
          long = received_data.substring(5, received_data.length);
        }

        if (received_data.substring(0, 5) == 'lati:'){
          lati = received_data.substring(5, received_data.length);
        }

        _messageBuffer = dataString.substring(index);
      });
    }
    else {
      _messageBuffer = (
        backspacesCounter > 0 
          ? _messageBuffer.substring(0, _messageBuffer.length - backspacesCounter) 
          : _messageBuffer
        + dataString
      );
    }
  }


}
