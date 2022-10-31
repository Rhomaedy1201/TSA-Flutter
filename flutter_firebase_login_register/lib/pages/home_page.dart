import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_login_register/pages/maps_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final alamatTujuan = TextEditingController();

  int _counter = 0;
  String location = 'Belum Mendapatkan Lat dan Long, Silahkan Tekan Button';
  String address = 'Mencari Lokasi...';
  Position _myPosition = Position(
      longitude: 0,
      latitude: 0,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.deepPurple[400],
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello Selamat Datang",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "" + user.email!,
                              style: TextStyle(
                                  fontSize: 17, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              title: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              leading: Icon(
                Icons.logout_outlined,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Koordinat point",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              location,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Address",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('${address}'),
            ElevatedButton(
              onPressed: () async {
                Position position = await _getGeoLocationPosition();
                setState(() {
                  location = '${position.latitude}, ${position.longitude}';
                });
                getAddressFromLongLat(position);
              },
              child: Text('Get koordinat'),
              style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
            ),
            SizedBox(height: 10),
            TextFormField(
              autofocus: false,
              obscureText: false,
              controller: alamatTujuan,
              decoration: InputDecoration(
                hintText: 'Lokasi tujuan anda',
                contentPadding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.purple.shade100,
                elevation: 5.0,
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 42.0,
                  onPressed: () {
                    final intent = AndroidIntent(
                        action: 'action_view',
                        data: Uri.encodeFull(
                            'google.navigation:q=${alamatTujuan.text}&avoid=tf'),
                        package: 'com.google.android.apps.maps');
                    intent.launch();
                  },
                  color: Colors.deepPurple,
                  child: Text('Cari Alamat',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location Services Belum Aktif.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions Ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location Permission Ditolak, Gagal Request Permission.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }
}
