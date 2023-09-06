import 'dart:convert';
import 'dart:typed_data';
import 'package:dutatani_mapping_iot/model/lahan.dart';
import 'package:dutatani_mapping_iot/model/dLahan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;


class DetailLahan extends StatefulWidget {
  final VoidCallback reload;
  final BluetoothDevice server;
  final Lahan lahan;

  const DetailLahan({Key key,@required this.lahan, @required this.server, this.reload}): super(key:key);
  @override
  _DetailLahanState createState() => _DetailLahanState();
}

class _DetailLahanState extends State<DetailLahan> {
  
  List <DLahan> _listDetail = [];
  final Set<Marker> _markers = {};
  LatLng _currentPosition,_cameraPos;
  String longitude, latitude;
  var lati = [];
  var loti = [];

  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  int _polygonIdCounter = 1;
  PolygonId selectedPolygon;

  static final clientID = 0;
  static final maxMessageLength = 4096 - 3;
  BluetoothConnection connection;

  String _messageBuffer = '';

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

cek() {
    // final form = _key.currentState;

    print("haiii cek");
    // if (form.validate()) {
    //   form.save();
      //  print("$username, $password");
      simpanData();
    // }
  }

  simpanData() async{
    final response = await http.post(
    "http://dutatani.id/si_mapping/api/insert_one_titik_lahan.php",
    body: {
      "id_lahan": widget.lahan.ID_Lahan,
      "lat" : latitude,
      "longt" : longitude
    });
    final data = jsonDecode(response.body);
    int statusData = data['status'];
   
    if(statusData == 1){
        print('yey'); 
        fetchData();      
        }else{
          print(print);
        }
  }


  void _add() {
    final int polygonCount = polygons.length;

    if (polygonCount == 12) {
      return;
    }

    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    _polygonIdCounter++;
    final PolygonId polygonId = PolygonId(polygonIdVal);

    final Polygon polygon = Polygon(
      polygonId: polygonId,
      consumeTapEvents: true,
      strokeColor: Colors.red,
      strokeWidth: 2,
      fillColor: Color.fromARGB(110, 255, 164,0 ),
      points: _createPoints(),
      onTap: () {
        _onPolygonTapped(polygonId);
      },
    );

    setState(() {
      polygons[polygonId] = polygon;
    });
  }

 void _onPolygonTapped(PolygonId polygonId) {
    setState(() {
      selectedPolygon = polygonId;
    });
  }

   int strokeColorsIndex = 0;
  int fillColorsIndex = 2;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  final List<LatLng> points = <LatLng>[];


  Future<Null> fetchData() async{
    final response =
    await http.get("http://dutatani.id/si_mapping/api/read_one_detail_lahan.php?id_lahan="+widget.lahan.ID_Lahan);
    // print(response.body);
    if(response.statusCode ==  200){
      final detailLahan =  jsonDecode(response.body);

      setState(() {
        _listDetail.clear();
        for (Map i in detailLahan){
          // points.add(_createLatLng(DLahan.formJson(i).lat, DLahan.formJson(i).longt));
          _listDetail.add(DLahan.formJson(i));
        }
  
      });
      

      _createPoints();
      _add();
    }
  }

  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    points.clear();
    for(var i in _listDetail){
      points.add(_createLatLng(double.tryParse(i.lat), double.tryParse(i.longt)));
      
      // _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(i.id_detail),
          position:LatLng(double.tryParse(i.lat), double.tryParse(i.longt)),
          icon: BitmapDescriptor.defaultMarkerWithHue(32.0) 
        ));
    } 
    return points;
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    
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



    // TODO: implement initState
    
    setState(() {
      _cameraPos = LatLng(double.tryParse(widget.lahan.lat), double.tryParse(widget.lahan.longt));
    });
    
   
  }


  mulai(){

  }

  @override
  void dispose() {
     if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }
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
        markerId: MarkerId("$longitude.toString(), $latitude.toString()"),
        position: _currentPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(96.0),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
         onPressed: (){Navigator.pop(context,true);}
        ),
        centerTitle: true,
        elevation: 0.0,
        title: Text("DETAIL LAHAN ID "+widget.lahan.ID_Lahan),
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
        children: <Widget>[
          Container(
           height: 480.0,
            child: GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: 
              CameraPosition(
                // target: LatLng(-7.786650869532198, 110.37848766893148),
                target: _cameraPos,
                zoom: 19.0, 
              ),
              markers: _markers,
              polygons: Set<Polygon>.of(polygons.values),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20.0),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          elevation: 0.0,
                          minWidth: 300.0,
                          height: 46.0,
                          color: Color(0xFF1B5E20).withOpacity(0.8),
                          onPressed: () {
                            cek();
                          },
                          child: Text(
                            "TAMBAH TITIK LAHAN",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 14.0),
                          ),
                        )
          )
        ]):Text('Got disconnected',
          style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontFamily: "Roboto"
            ),
        ),
      ), 
    
    );
  }
}