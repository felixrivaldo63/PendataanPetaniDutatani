import 'package:dutatani_mapping_iot/bluetooth/SelectBondedDevicePage.dart';
import 'package:dutatani_mapping_iot/bluetooth/scan_device.dart';
import 'package:dutatani_mapping_iot/contoh.dart';
import 'package:dutatani_mapping_iot/detail_lahan.dart';
import 'package:dutatani_mapping_iot/model/lahan.dart';
import 'package:dutatani_mapping_iot/tambah_lahan.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dutatani_mapping_iot/model/petani.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


class DataLahan extends StatefulWidget {
  final Petani data;
  
  const DataLahan({Key key, @required this.data}): super(key:key);
 
  @override
  _DataLahanState createState() => _DataLahanState();
}


class _DataLahanState extends State<DataLahan> {
  List<Lahan> _list = [];
  var loading = true;
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scafKey = new GlobalKey<ScaffoldState>();
  


  Future<Null> fetchData() async{
    setState(() {
      loading =  true;
    });
    _list.clear();
    final response = 
    await http.get("http://dutatani.id/si_mapping/api/read_lahan_one_petani_simple.php?id_user="+widget.data.ID_User);
    // print(response.body);
    if(response.body.isEmpty){
        print("data kosong");
        setState(() {
          loading = false;
    });
    }
    
    if(response.statusCode == 200){
      final dataLahan = jsonDecode(response.body);      
      setState(() {
        for (Map i in dataLahan){
          _list.add(Lahan.formJson(i));
          loading = false;
          // print(dataLahan);
        }
      });
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff009c41), accentColor: Colors.deepOrangeAccent),
      debugShowCheckedModeBanner: false,
      
      home: Scaffold(
        key: _scafKey,
        appBar: AppBar(
          centerTitle: true,leading: BackButton(
         onPressed: (){Navigator.pop(context,true);}
        ),
          title: Text(
            'DAFTAR LAHAN '+widget.data.ID_User
          ),
          elevation: 0.0,
        ),
          body: RefreshIndicator(
            onRefresh: fetchData,
            key: _refresh,
            child:Container(
              child: Column(
                children: <Widget>[
                  Container(
                     child: loading ? Center(child: CircularProgressIndicator(),) : Expanded(child: InkWell(
                  child: ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (context, i){
                    final a = _list[i];
                    return Container(
                      padding: EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.blueGrey,
                            width: 0.4
                        ),
                      ),
                      child: ListTile(
                        title: Text("ID "+a.ID_Lahan, style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0
                        ),),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(a.nama_lahan+" || Luas Lahan "+a.luas_lahan+"m2"),
                            Text(a.status_organik+" || "+a.jenis_lahan),
                            Text("Desa "+a.Desa)
                          ],
                        ),
                        
                        onTap: (){
                            showCupertinoModalPopup(
                              context: context, 
                              builder: (context){
                               return CupertinoActionSheet(
                                 title: Text("Pilih Aksi Lahan "+ widget.data.ID_User+" ID "+a.ID_Lahan, 
                                 style: TextStyle(
                                 fontWeight: FontWeight.bold,
                                 fontSize: 18.0
                                 ),
                                 ),
                                 message: Text("Silahkan untuk menghubungkan perangkat modul IoT terlebih dahulu untuk mendokumentasikan titik lahan"),
                                 cancelButton: CupertinoActionSheetAction(onPressed: (){Navigator.of(context).pop();}, child: Text("Batal")),
                                 actions: <Widget>[
                                   CupertinoActionSheetAction(onPressed: () async {
                                     final BluetoothDevice selectedDevice = await Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) { return SelectBondedDevicePage(checkAvailability: false); }) );
                                      if (selectedDevice != null) {
                                            print('Connect -> selected ' + selectedDevice.address);
                                            _startMappingDetail(context, selectedDevice, a);
                                        }
                                        else {
                                        print('Connect -> no device selected');
                                        }

                                    //  Navigator.of(context).push(MaterialPageRoute(builder:(context){ return DetailLahan(lahan: a);}));
                                   }, child: Text("Detail Titik Lahan",)),
                                   CupertinoActionSheetAction(onPressed: ()async{
                                    final response = 
                                    await http.get("http://dutatani.id/si_mapping/api/delete_lahan.php?id_lahan="+a.ID_Lahan);
                                    if(response.statusCode==200){
                                      fetchData();
                                      setState(() {
                                        
                                      });
                                      Navigator.of(context).pop();
                                    }

                                   }, child: Text("Hapus Data Lahan")),
                                  
                                 ],

                               );
                              });
                         
                        },
                      ),
                  
                    );
                  }),
                ))
                  )
                ],
               
              )
                
            )
            
            ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
           final BluetoothDevice selectedDevice = await Navigator.of(context).push(
           MaterialPageRoute(builder: (context) { return SelectBondedDevicePage(checkAvailability: false); }) );
           if (selectedDevice != null) {
                print('Connect -> selected ' + selectedDevice.address);
                _startMapping(context, selectedDevice);
            }
            else {
            print('Connect -> no device selected');
            }
          },
          child: Icon(Icons.add, size: 30.0,color: Colors.white,),
          backgroundColor: Color(0xff009c41),
          elevation: 0.0,
        ),
        
      ),
    );
  }
  void _startMapping(BuildContext context, BluetoothDevice server){
    Navigator.of(context).push(MaterialPageRoute(builder:(context){ return TambahLahan(server: server, data: widget.data);}));
  }
   void _startMappingDetail(BuildContext context, BluetoothDevice server, Lahan a){
    Navigator.of(context).push(MaterialPageRoute(builder:(context){ return DetailLahan(server: server, lahan: a);}));
  }
}