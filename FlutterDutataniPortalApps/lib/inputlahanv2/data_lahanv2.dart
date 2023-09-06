import 'package:dutatani_mapping_iot/inputlahanv2/detail_lahanv2.dart';
import 'package:dutatani_mapping_iot/inputlahanv1/detail_lahanv1.dart';
import 'package:dutatani_mapping_iot/model/lahan.dart';
import 'package:dutatani_mapping_iot/inputlahanv2/tambah_lahanv2.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dutatani_mapping_iot/model/petani.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataLahanV2 extends StatefulWidget {
  final Petani data;
  
  const DataLahanV2({Key key, @required this.data}): super(key:key);
 
  @override
  _DataLahanState createState() => _DataLahanState();
}


class _DataLahanState extends State<DataLahanV2> {
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
                                 cancelButton: CupertinoActionSheetAction(onPressed: (){Navigator.of(context).pop();}, child: Text("Batal")),
                                 actions: <Widget>[
                                   CupertinoActionSheetAction(onPressed: () async {
                                       SharedPreferences preferences = await SharedPreferences.getInstance();
                                       String menu = preferences.getString("menu");
                                       if(menu == "lahanv2"){
                                         Navigator.of(context).push(MaterialPageRoute(builder:(context){ return DetailLahanV2(lahan: a);}));
                                       }else{
                                         Navigator.of(context).push(MaterialPageRoute(builder:(context){ return DetailLahanV1(lahan: a);}));
                                       }
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
            _startMapping(context);
          },
          child: Icon(Icons.add, size: 30.0,color: Colors.white,),
          backgroundColor: Color(0xff009c41),
          elevation: 0.0,
        ),
        
      ),
    );
  }
  void _startMapping(BuildContext context) async{
    Navigator.of(context).push(MaterialPageRoute(builder:(context){ return TambahLahanV2(data: widget.data);}));
  }
   void _startMappingDetail(BuildContext context, Lahan a){
    Navigator.of(context).push(MaterialPageRoute(builder:(context){ return DetailLahanV2(lahan: a);}));
  }
}