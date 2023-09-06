import 'dart:ffi';

import 'package:dutatani_mapping_iot/inputlahanv2/data_lahanv2.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dutatani_mapping_iot/model/petani.dart';
import 'package:dutatani_mapping_iot/tambah_petani.dart';

class DaftarPetaniV2 extends StatefulWidget {
  @override
  _DaftarPetaniState createState() => _DaftarPetaniState();
}

class _DaftarPetaniState extends State<DaftarPetaniV2> {
  List<Petani> _list = [];
  List<Petani> _search = [];
  var loading = true;
  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();


  Future<Void> fetchData() async {
    setState(() {
      loading = true;
    });
    _list.clear();
    final response =
        await http.get("http://dutatani.id/si_mapping/api/read_petani.php");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data) {
          _list.add(Petani.formJson(i));
          loading = false;
          //  print(data);
        }
      });
    }
  }

  Future pageBaru(context) async {
  Navigator.of(context).push( MaterialPageRoute(builder: (context) => TambahPetani(fetchData)));
}

  TextEditingController controller = new TextEditingController();
  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _list.forEach((f) {
      if (f.ID_User.contains(text) || f.Nama_Petani.contains(text))
        _search.add(f);
    });
    setState(() {});
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
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            'DAFTAR PETANI',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.person_add,
                  size: 30.0,
                ),
                onPressed: () {
                  pageBaru(context);
                })
          ],
        ),
        body: RefreshIndicator(
          onRefresh: fetchData,
          key:  _refresh,

          child: Container(
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.all(3.0),
                color: Color(0xff009c41),
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.search),
                    title: TextField(
                      controller: controller,
                      onChanged: onSearch,
                      decoration: InputDecoration(
                          hintText: "Cari Petani", border: InputBorder.none),
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          controller.clear();
                          onSearch('');
                        }),
                  ),
                ),
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: _search.length != 0 || controller.text.isNotEmpty
                          ? InkWell(
                              child: ListView.builder(
                              itemCount: _search.length,
                              itemBuilder: (context, i) {
                                final b = _search[i];
                                return Container(
                                   padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blueGrey,
                                            width: 0.4
                                        ),
                                      ),
                                  child: ListTile(
                                    title:  Text(
                                          b.ID_User,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),  
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                       
                                        Text("Nama Petani: " + b.Nama_Petani.toString()),
                                        Text("Total Jumlah Lahan: " + b.jml_lahan),
                                        Text("Jumlah Lahan teridentifikasi: " +
                                            b.jml_tercatat),
                                        Text("Lahan yang bisa ditambahkan: " +
                                            b.bisa)
                                      ],
                                    ),
                                     onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context){return DataLahanV2(data:b);} ,),);
                                    },
                                  )
                                );
                              },
                            ))
                          : InkWell(
                             hoverColor: Colors.grey,
                               child: ListView.builder(
                                itemCount: _list.length,
                                itemBuilder: (context, i) {
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
                                    title: Text(
                                            a.ID_User,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                          ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                         
                                          Text("Nama Petani: " + a.Nama_Petani.toString()),
                                          Text(
                                              "Total Jumlah Lahan: " + a.jml_lahan),
                                          Text("Jumlah Lahan teridentifikasi: " +
                                              a.jml_tercatat),
                                          Text("Lahan yang bisa ditambahkan: " +
                                              a.bisa)
                                        ],
                                        
                                      ),
                                      onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => DataLahanV2(data:a),),);
                                    },
                                    
                                    )
                                  );
                                },
                              ),
                            ),
                    )
            ]),
          ),
        ),
      ),
    );
  }
}
