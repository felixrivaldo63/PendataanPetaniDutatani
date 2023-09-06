import 'package:dutatani_mapping_iot/daftar_petani.dart';
import 'package:dutatani_mapping_iot/inputlahanv2/daftar_petaniv2.dart';
import 'package:dutatani_mapping_iot/login_page.dart';
import 'package:flutter/material.dart';
import 'package:dutatani_mapping_iot/tambah_petani.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;




//navigasi tab bedasarkan index
  final tabs = [
    Home(),
    Center(child: Text("Dashboard akan segera tersedia :)")),
    Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          'DUTATANI',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),
            // backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text("Dashboard"),
            // backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            // backgroundColor: Colors.white
          ),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),

    );
  }


}

//isi home
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void tambahPetaniArg(){
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 4,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        children: <Widget>[
          MenuHome(
            icon: Icons.add_location,
            iconColor : Colors.blue,
            label : 'Lahan by GPS',
            navRoute: ()async{
              final SharedPreferences preferences = await SharedPreferences.getInstance();
              setState(() {
                preferences.setString("menu", "lahanv1");
                preferences.commit();
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) =>DaftarPetaniV2(),));
            },
          ),
          MenuHome(
            icon: Icons.map,
            iconColor : Colors.lightGreen,
            label : 'Lahan by Map',
            navRoute: () async{
              final SharedPreferences preferences = await SharedPreferences.getInstance();
              setState(() {
                preferences.setString("menu", "lahanv2");
                preferences.commit();
              });
              Navigator.push(context, MaterialPageRoute(builder: (context) =>DaftarPetaniV2(),));
            },
          ),
          MenuHome(
            icon: Icons.accessibility_new,
            iconColor : Colors.deepPurple,
            label : 'Input Petani',
            navRoute: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>TambahPetani(this.tambahPetaniArg),));
            },
          ),
          MenuHome(
            icon: Icons.settings_input_antenna,
            iconColor : Colors.deepOrange,
            label : 'Mapping IoT',
            navRoute: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>DaftarPetani(),));
            },
          ),
        ],
      ),
    );
  }
}

class MenuHome extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final Function navRoute;

  MenuHome({
    this.icon,
    this.iconColor,
    this.label,
    this.navRoute
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: navRoute,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: iconColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Icon(icon, color: iconColor, size: 40.0),
                ),
              ),
              SizedBox(height: 6.0),
              Text(label, style: TextStyle(fontSize: 12.0),overflow: TextOverflow.ellipsis)
            ],
          ),
        )
    );
  }
}


class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  signOut()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.commit();
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){ return LoginPage();}));

  }
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(10.0))),
              elevation: 0.0,
              minWidth: 200.0,
              height: 45,
              color: Color(0xff009c41).withOpacity(0.8),
              onPressed:  (){
                signOut();
              },
              child: Text(
                "LOGOUT",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
        )
    );
  }
}