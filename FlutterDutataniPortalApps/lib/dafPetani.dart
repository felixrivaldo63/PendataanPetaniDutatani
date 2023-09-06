import 'dart:ui';
import 'package:dutatani_mapping_iot/apiservices.dart';
import 'package:dutatani_mapping_iot/model.dart';
import 'package:dutatani_mapping_iot/updatePetani.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';


class DafPetani extends StatefulWidget {
  DafPetani({Key key, this.id_adm}) : super(key: key);
  final String id_adm;


  @override
  _DafPetaniState createState() => _DafPetaniState(id_adm);
}

class _DafPetaniState extends State<DafPetani> {
  final _formkey = GlobalKey<FormState>();

  List<Petani> lptn = new List();

  final String id_adm;
  _DafPetaniState(this.id_adm);

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }


  @override
  void initState() {
    //print("NIM yang Sedang Login : " + this.nim_login);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xff009c41),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Daftar Petani"),
          backgroundColor: Color(0xff009c41),
          elevation: 0,
          centerTitle: true,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (a, b, c) => DafPetani(id_adm: this.id_adm,),
                transitionDuration: Duration(seconds: 0),
              ),
            );
            return Future.value(false);
          },
          child: Container(
            child: FutureBuilder(
                future: ApiServices().getDafPet(),
                builder: (BuildContext context, AsyncSnapshot<List<Petani>> snapshot){
                  if(snapshot.hasError){
                    return Center(
                      child: Text(
                        "Something wrong with message : ${snapshot.error.toString()}",
                        style: TextStyle(
                          color: Color(0xff009c41),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }else if(snapshot.connectionState == ConnectionState.done){
                    lptn = snapshot.data;
                    return ListView.builder(
                      itemBuilder: (context, position){
                        return Card(
                          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          shadowColor: Color(0xff009c41),
                          elevation: 2.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5, 2.5, 5, 2.5),
                            margin: EdgeInsets.fromLTRB(2.5, 2.5, 2.5, 2.5),
                            child: ListTile(
                              title: Text(
                                //lDsn[position].nik
                                lptn[position].id.toString(),
                                style: TextStyle(
                                  color: Color(0xff009c41),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                lptn[position].email.toString(),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.black26,
                                  size: 20,
                                ),
                              ),
                              onLongPress: (){
                                showDialog(
                                    context: context,
                                    builder: (_) => new AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              "Update",
                                              style: TextStyle(
                                                color: Color(0xFFAB47BC),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => UpdatePetani(id_adm: this.id_adm, id_ptn: lptn[position].id, pet: lptn[position],))).then(onGoBack);
                                            },
                                          ),
                                          Divider(
                                            color: Colors.black,
                                            height: 20,
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                            onPressed: () async {
                                              ApiServices().delPetani(lptn[position].id).then(onGoBack);
                                              // print("Data = " + lptn[position].id.toString());
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                          )
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          ),
                        );
                      },
                      itemCount: lptn.length,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xff009c41),),
                        backgroundColor: Colors.grey,
                        strokeWidth: 7,
                      ),
                    );
                  }
                }
            ),
          ),
        ),
      ),
    );
  }
}