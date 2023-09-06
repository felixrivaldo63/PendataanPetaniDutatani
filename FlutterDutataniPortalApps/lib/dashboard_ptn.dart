import 'package:dutatani_mapping_iot/apiservices.dart';
import 'package:dutatani_mapping_iot/daftar_petani.dart';
import 'package:dutatani_mapping_iot/inputlahanv2/daftar_petaniv2.dart';
import 'package:dutatani_mapping_iot/login_page.dart';
import 'package:dutatani_mapping_iot/model.dart';
import 'package:dutatani_mapping_iot/pendataan_personal.dart';
import 'package:dutatani_mapping_iot/profilPetani.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dutatani_mapping_iot/tambah_petani.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPtn extends StatefulWidget {
  DashboardPtn({Key key, this.id_ptn}) : super(key: key);
  final String id_ptn;

  @override
  _DashboardPtnState createState() => _DashboardPtnState(id_ptn);
}

// SelectedItem(BuildContext context, item) async {
//   switch (item) {
//     case 0:
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => ProfilPtn()));
//       print("Profile");
//       break;
//     case 1:
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       await pref.setInt("value", null);
//       await pref.commit();
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => LoginPage()));
//       break;
//   }
// }

class _DashboardPtnState extends State<DashboardPtn> {
  final String id_ptn;

  _DashboardPtnState(this.id_ptn);

  List<Petani> lPet = new List();

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));
  }

  SelectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilPtn(
                      id_ptn: this.id_ptn,
                    )));
        print("Profile");
        break;
      case 1:
        signOut();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            //Custom AppBar
            Container(
              // margin: EdgeInsets.only(left: 16, right: 16, top: 16),
              color: Color(0xff009c41),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset(
                    "assets/images/logo_dutatani_2.png",
                    width: 120,
                    height: 59,
                  ),
                  PopupMenuButton<int>(
                    elevation: 40,
                    child: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 35,
                    ),
                    offset: Offset(0, 60),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: FutureBuilder<Petani>(
                          future: ApiServices().getPetani(this.id_ptn),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.data == null) {
                                return Text('no data');
                              } else {
                                return Text(
                                  snapshot.data.nama,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20),
                                );
                              }
                            } else if (snapshot.connectionState ==
                                ConnectionState.none) {
                              return Text('Error'); // error
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                    "Something Wrong With Message: ${snapshot.error.toString()}"),
                              );
                            } else {
                              return CircularProgressIndicator(); // loading
                            }
                          },
                          // child: Text(
                          //   this.id_ptn,
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.black,
                          //       fontSize: 20),
                          // ),
                        ),
                        // value: 0,
                      ),
                      PopupMenuItem<int>(
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Color(0xff009c41),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text("Profile",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff009c41))),
                          ],
                        ),
                        value: 0,
                      ),
                      PopupMenuDivider(),
                      PopupMenuItem<int>(
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text("Logout",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red)),
                          ],
                        ),
                        value: 1,
                      ),
                    ],
                    onSelected: (item) => SelectedItem(context, item),
                  )
                ],
              ),
            ),
            //Card Section
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Divider(
                      color: Color(0xff009c41), thickness: 2.5, endIndent: 10),
                  Text(
                    'MENU PETANI',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff009c41)),
                  ),
                  Divider(
                    color: Color(0xff009c41),
                    thickness: 2.5,
                    endIndent: 10,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 10, top: 5),
              height: 455,
              width: 172,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xff009c41),
              ),
              // child: Container(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 2.6,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                primary: false,
                children: <Widget>[
                  FutureBuilder<Petani>(
                      future: ApiServices().getPetani(this.id_ptn),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data == null) {
                            return Text('no data');
                          } else {
                            return GestureDetector(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 20,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.person,
                                      size: 90,
                                      color: Color(0xff000D9C),
                                    ),
                                    Text(
                                      'Pendataan Personal Petani',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff000D9C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PendataanPers(
                                            id_ptn: this.id_ptn, pet: snapshot.data,
                                          )),
                                );
                              },
                            );
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.none) {
                          return Text('Error'); // error
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                "Something Wrong With Message: ${snapshot.error.toString()}"),
                          );
                        } else {
                          return CircularProgressIndicator(); // loading
                        }
                      }),
                  GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.book_online,
                            size: 90,
                            color: Color(0xff9C8F00),
                          ),
                          Text(
                            'Menu Learning',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff9C8F00),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      await LaunchApp.openApp(
                        androidPackageName: 'com.example.online_course',
                        // openStore: false
                      );
                    },
                  ),
                  GestureDetector(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 20,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.shopping_cart,
                            size: 90,
                            color: Color(0xff9C005B),
                          ),
                          Text(
                            'Menu Commerce',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff9C005B),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      await LaunchApp.openApp(
                        androidPackageName: 'fti.ukdw.ac.id.duta_tani_ui',
                        // openStore: false
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
