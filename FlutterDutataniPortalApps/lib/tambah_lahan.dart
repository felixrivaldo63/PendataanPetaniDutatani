
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:http/http.dart' as http;
import 'package:dutatani_mapping_iot/model/petani.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:dutatani_mapping_iot/model/DataWilayah.dart';




class TambahLahan extends StatefulWidget {
 final VoidCallback reload;
 final BluetoothDevice server;
 final Petani data;
  
  const TambahLahan({Key key, @required this.server, @required this.data, this.reload}): super(key:key);
  @override
  _TambahLahanState createState() => _TambahLahanState();
  
}

class _TambahLahanState extends State<TambahLahan> {
final _key = new GlobalKey<FormState>();
GlobalKey<AutoCompleteTextFieldState<String>> key_autocomplete = new GlobalKey();
String namaLahan, jenisLahan, statusOrg, statusLahan, provinsi, kabupaten, kecamatan, desa;
int luasLahan;
String longitude, latitude;
 

List _jenisLahan = ["Sawah","Tegalan"];
List _statusOrg = ["Organik", "Non-Organik"];
List _statusLahan = ["Milik","Sewa","Garap"];

 final Set<Marker> _markers = {};
  SimpleAutoCompleteTextField textFieldProv;
  SimpleAutoCompleteTextField textFieldKab;
  SimpleAutoCompleteTextField textFieldKec;
  SimpleAutoCompleteTextField textFieldDesa;
  final controlProv = TextEditingController();
  final controlKab = TextEditingController();
  final controlKec = TextEditingController();
  final controlDesa = TextEditingController();


  LatLng _currentPosition; 

 static final clientID = 0;
  static final maxMessageLength = 4096 - 3;
  BluetoothConnection connection;

  String _messageBuffer = '';

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;


  cek() {
    final form = _key.currentState;

    print("haiii cek");
    if (form.validate()) {
      form.save();
      //  print("$username, $password");
      simpanData();
    }
  }

  simpanData() async {
  final response = await http.post(
    "http://dutatani.id/si_mapping/api/insert_lahan.php",
    body: {
      "ID_User": widget.data.ID_User,
      "nama_petani": widget.data.Nama_Petani,
      "lat" : latitude,
      "longt" : longitude,
      "nama_lahan": namaLahan,
      "luas_lahan":luasLahan.toString(),
      "status_lahan":statusLahan,
      "jenis_lahan":jenisLahan,
      "status_organik":statusOrg,
       "provinsi":controlProv.text,
      "Kabupaten":controlKab.text,
      "Kecamatan":controlKec.text,
      "Desa_Kelurahan":controlDesa.text
    });
    Navigator.pop(context);
    final data = jsonDecode(response.body);
    int statusData = data['status'];
    if(statusData == 1){
           widget.reload();
          Navigator.pop(context);
        }else{
          print(print);
        }
  }

 @override
  void initState() {
    
   // TODO: implement initState
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection){
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
    });
    connection.input.listen(_onDataReceived).onDone((){
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
    controlProv.dispose();
    controlKab.dispose();
    controlKec.dispose();
    controlDesa.dispose();
    super.dispose();
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
       // print(received_data);
//        print(received_data.substring(0, 4));
//        print(received_data.length);
        if (received_data.substring(0, 5) == 'long:'){
          setState(() {
            longitude = received_data.substring(5, received_data.length);
          });
        }

        if (received_data.substring(0, 5) == 'lati:'){
          setState(() {
            latitude = received_data.substring(5, received_data.length);
          });
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

    setState(() {
      _currentPosition = LatLng(double.tryParse(latitude), double.tryParse(longitude));
      _markers.clear();
    });
      _markers.add(
      Marker(
        markerId: MarkerId("point"),
        position: _currentPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(96.0),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    textFieldProv = SimpleAutoCompleteTextField(
      //key: key_autocomplete,
      controller: controlProv,
      suggestions: DataWilayah().dataProv,
      textChanged: (text) => text,
      clearOnSubmit: true,
      decoration: InputDecoration(labelText: "Provinsi"),
    );

    textFieldKab = SimpleAutoCompleteTextField(
      controller: controlKab,
      suggestions: DataWilayah().dataKab,
      textChanged: (text) => text,
      clearOnSubmit: true,
      decoration: InputDecoration(labelText: "Kabupaten")
    );

    textFieldKec = SimpleAutoCompleteTextField(
      controller: controlKec,
      suggestions: DataWilayah().dataKec,
      textChanged: (text) => text,
      clearOnSubmit: true,
      decoration: InputDecoration(labelText: "Kecamatan")
    );

    textFieldDesa = SimpleAutoCompleteTextField(
      controller: controlDesa,
      suggestions: DataWilayah().dataDesa,
      textChanged: (text) => text,
      clearOnSubmit: true,
      decoration: InputDecoration(labelText: "Desa")
    ); 


    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
         onPressed: (){Navigator.pop(context,true);}
        ),
        centerTitle: true,
        elevation: 0.0,
        title:  isConnecting ? Text('Tambah Lahan Menghubungi ' + widget.server.name + '...') :
          isConnected ? Text('Tambah Lahan Terhubung ' + widget.server.name) :
          Text('Terputus ' + widget.server.name),
      ),
     body: Center(
          child: isConnecting ? Text('Tunggu Koneksi Bluetooth...',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontFamily: "Roboto"
            ),
          )
          :
          isConnected ?
       Column(
       children:<Widget>[
         Expanded(
           child:  Form(
            key: _key,  
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: ListView(
                children: <Widget>[
                   Container(
                          height: 250,
                          child :GoogleMap(
                            zoomGesturesEnabled: true,
                            tiltGesturesEnabled: false,
                            mapType: MapType.satellite,
                            initialCameraPosition: CameraPosition(
                            target: _currentPosition,
                            zoom: 19.0,
                    ),
                    markers: _markers,
                    ),
                    ),
                    Divider(),
                  TextFormField(
                    initialValue: widget.data.Nama_Petani,
                    readOnly: true,
                    decoration: InputDecoration(labelText: "Nama Petani"),
                  ),
                  TextFormField(
                    onSaved: (e) => namaLahan = e,
                    decoration: InputDecoration(labelText: "Nama Lahan"),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number, 
                    onSaved: (input) => luasLahan = num.parse(input),
                    decoration: InputDecoration(labelText: "Luas Lahan (m2)"),
                  ),
                   Container(
                   padding: EdgeInsets.only(top:10, bottom:2),
                   child: DropdownButton(
                     hint: Text("Status Lahan"),
                     value: statusLahan,
                     items: _statusLahan.map((value){
                       return DropdownMenuItem(
                         child: Text(value),
                         value: value,
                       );
                     }).toList(),
                     onChanged: (value){
                       setState(() {
                         statusLahan = value;
                       });
                     },
                   ),
                 ),
                 Container(
                   padding: EdgeInsets.only(top:10, bottom:2),
                   child: DropdownButton(
                     hint: Text("Jenis Lahan"),
                     value: jenisLahan,
                     items: _jenisLahan.map((value){
                       return DropdownMenuItem(
                         child: Text(value),
                         value: value,
                       );
                     }).toList(),
                     onChanged: (value){
                       setState(() {
                         jenisLahan = value;
                       });
                     },
                   ),
                 ),
                 Container(
                   padding: EdgeInsets.only(top:10, bottom:2),
                   child: DropdownButton(
                     hint: Text("Status Organik"),
                     value: statusOrg,
                     items: _statusOrg.map((value){
                       return DropdownMenuItem(
                         child: Text(value),
                         value: value,
                       );
                     }).toList(),
                     onChanged: (value){
                       setState(() {
                         statusOrg = value;
                       });
                     },
                   ),
                 ),
                   textFieldProv,
                  textFieldKab,
                  textFieldKec,
                  textFieldDesa,
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        elevation: 0.0,
                        minWidth: 200.0,
                        height: 45,
                        color: Color(0xff009c41).withOpacity(0.8),
                        onPressed: () {
                          cek();
                        },
                        child: Text(
                          "SIMPAN",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ))

                ],
              ),
            ))
           ),       
        
       ]):
        Text('Got disconnected',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontFamily: "Roboto"
            ),)

     )
    );
  }

}