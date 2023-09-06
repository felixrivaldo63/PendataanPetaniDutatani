import 'package:carousel_slider/carousel_slider.dart';
import 'package:dutatani_mapping_iot/apiservices.dart';
import 'package:dutatani_mapping_iot/dafPetani.dart';
import 'package:dutatani_mapping_iot/daftar_petani.dart';
import 'package:dutatani_mapping_iot/inputlahanv2/daftar_petaniv2.dart';
import 'package:dutatani_mapping_iot/login_page.dart';
import 'package:dutatani_mapping_iot/model.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardAdm extends StatefulWidget {
  DashboardAdm({Key key, this.id_adm}) : super(key: key);
  final String id_adm;

  // DataDashboard datDash;
  @override
  _DashboardAdmState createState() => _DashboardAdmState(id_adm);
}

class _DashboardAdmState extends State<DashboardAdm> {
  final String id_adm;

  _DashboardAdmState(this.id_adm);

  int _currentIndex = 0;

  List cardList = [Item1(), Item2(), Item3(), Item4()];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

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
            context, MaterialPageRoute(builder: (context) => DashboardAdm()));
        print("Profile");
        break;
      case 1:
        signOut();
        break;
    }
  }

  // List<DataDashboard> lData = new List();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xff009c41),
      ),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (a, b, c) => DashboardAdm(
                  id_adm: this.id_adm,
                ),
                transitionDuration: Duration(seconds: 0),
              ),
            );
            return Future.value(false);
          },
          child: Container(
            // margin: EdgeInsets.only(top: 8),
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
                            child: Text(
                              this.id_adm,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                            // value: 0,
                          ),
                          // PopupMenuItem<int>(
                          //   child: Row(
                          //     children: [
                          //       Icon(
                          //         Icons.person,
                          //         color: Color(0xff009c41),
                          //       ),
                          //       const SizedBox(
                          //         width: 7,
                          //       ),
                          //       Text("Profile",
                          //           style: TextStyle(
                          //               fontWeight: FontWeight.bold,
                          //               color: Color(0xff009c41))),
                          //     ],
                          //   ),
                          //   value: 0,
                          // ),
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
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Divider(
                          color: Color(0xff009c41),
                          thickness: 2.5,
                          endIndent: 10),
                      Text(
                        'DASHBOARD',
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
                Column(
                  children: <Widget>[
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 200.0,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        pauseAutoPlayOnTouch: true,
                        aspectRatio: 2.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                      items: cardList.map((card) {
                        return Builder(builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.30,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              color: Colors.blueAccent,
                              child: card,
                            ),
                          );
                        });
                      }).toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: map<Widget>(cardList, (index, url) {
                        return Container(
                          width: 10.0,
                          height: 10.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? Colors.blueAccent
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Divider(
                          color: Color(0xff009c41),
                          thickness: 2.5,
                          endIndent: 10),
                      Text(
                        'MENU ADMIN',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff009c41)),
                      ),
                      Divider(
                          color: Color(0xff009c41),
                          thickness: 2.5,
                          endIndent: 10),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 10, top: 5),
                  height: 75,
                  width: 172,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xff009c41),
                  ),
                  // child: Container(
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 25,
                    primary: false,
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 20,
                        child: GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.map,
                                size: 35,
                                color: Color(0xff009c41),
                              ),
                              Align(
                                alignment: Alignment.center,
                              ),
                              Text(
                                'Mapping',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff009c41),
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            // signOut();
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         // builder: (context) =>
                            //         //     DashboardMahasiswa(
                            //         //         title: "Dashboard Mahasiswa")),).then(onGoBack);
                            //         ));
                          },
                        ),
                      ),
                      // Card(
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(15)),
                      //   elevation: 20,
                      //   child: GestureDetector(
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: <Widget>[
                      //         Icon(
                      //           Icons.keyboard,
                      //           size: 35,
                      //           color: Color(0xff009c41),
                      //         ),
                      //         Text(
                      //           'Input Urgent',
                      //           textAlign: TextAlign.center,
                      //           style: TextStyle(
                      //             fontSize: 11,
                      //             fontWeight: FontWeight.bold,
                      //             color: Color(0xff009c41),
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //     onTap: () {
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => DaftarPetani()));
                      //     },
                      //   ),
                      // ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 20,
                        child: GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                size: 35,
                                color: Color(0xff009c41),
                              ),
                              Text(
                                'Pendataan Petani',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff009c41),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DafPetani(
                                          id_adm: this.id_adm,
                                        )
                                    // builder: (context) => DaftarPetaniV2()
                                    ));
                          },
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 20,
                        child: GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.book_online,
                                size: 35,
                                color: Color(0xff009c41),
                              ),
                              Text(
                                'Menu Learing',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff009c41),
                                ),
                              )
                            ],
                          ),
                          onTap: () async {
                            await LaunchApp.openApp(
                              androidPackageName: 'com.example.online_course',
                              // openStore: false
                            );
                          },
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 20,
                        child: GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.shopping_cart,
                                size: 35,
                                color: Color(0xff009c41),
                              ),
                              Text(
                                'Menu Commerce',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff009c41),
                                ),
                              )
                            ],
                          ),
                          onTap: () async {
                            await LaunchApp.openApp(
                              androidPackageName: 'fti.ukdw.ac.id.duta_tani_ui',
                              // openStore: false
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Item1 extends StatelessWidget {
  const Item1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xffff4000),
              Color(0xffffcc66),
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Materi",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold)),
          FutureBuilder<DataDashboard>(
              // future: _getData(),
              future: ApiServices().getDashboard(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return Text('no data');
                  } else {
                    return Text(
                      snapshot.data.materi.toString(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }
                } else if (snapshot.connectionState == ConnectionState.none) {
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
        ],
      ),
    );
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 1],
            colors: [Color(0xff5f2c82), Color(0xff49a09d)]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Lahan",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold)),
          FutureBuilder<DataDashboard>(
              // future: _getData(),
              future: ApiServices().getDashboard(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return Text('no data');
                  } else {
                    return Text(
                      snapshot.data.lahan.toString(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }
                } else if (snapshot.connectionState == ConnectionState.none) {
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
        ],
      ),
    );
  }
}

class Item3 extends StatelessWidget {
  const Item3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.3,
              1
            ],
            colors: [
              Color(0xffff4000),
              Color(0xffffcc66),
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Petani",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold)),
          FutureBuilder<DataDashboard>(
              // future: _getData(),
              future: ApiServices().getDashboard(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return Text('no data');
                  } else {
                    return Text(
                      snapshot.data.petani.toString(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }
                } else if (snapshot.connectionState == ConnectionState.none) {
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
        ],
      ),
    );
  }
}

class Item4 extends StatelessWidget {
  const Item4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 1],
            colors: [Color(0xff5f2c82), Color(0xff49a09d)]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Berita",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold)),
          FutureBuilder<DataDashboard>(
              // future: _getData(),
              future: ApiServices().getDashboard(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return Text('no data');
                  } else {
                    return Text(
                      snapshot.data.berita.toString(),
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }
                } else if (snapshot.connectionState == ConnectionState.none) {
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
        ],
      ),
    );
  }
}
