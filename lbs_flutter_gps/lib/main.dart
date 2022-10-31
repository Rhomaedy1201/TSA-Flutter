import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:android_intent_plus/android_intent.dart';
// import 'package:platform/platform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String location = 'Belum mendapatkan Lat dan Long, Silahkan tekan button';
  String address = 'Mencari lokasi...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geolocation & Geocoding"),
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
                Position position = await _getGeolocationPosition();
                setState(() {
                  location = '${position.latitude}, ${position.longitude}';
                });
                getAddressFromLongLat(position);
              },
              child: Text('Get koordinat'),
            ),
            Text(
              "Tujuan Anda",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                hintText: 'Lokasi tujuan anda',
                contentPadding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Material(
                borderRadius: BorderRadius.circular(30),
                shadowColor: Colors.lightBlueAccent.shade100,
                elevation: 5,
                child: MaterialButton(
                  minWidth: 200,
                  height: 42,
                  onPressed: () {
                    final intent = AndroidIntent(
                        action: 'action view',
                        data: Uri.encodeFull(
                            'google.navigation:q=Taronga+Zoo,+Sydney+Australia&avoid=tf'),
                        package: 'com.google.android.apps.maps');
                    intent.launch();
                  },
                  color: Colors.lightBlueAccent,
                  child: Text(
                    'Cari Alamat',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Position> _getGeolocationPosition() async {
    bool servicesEnabled;
    LocationPermission permission;

    servicesEnabled = await Geolocator.isLocationServiceEnabled();
    if (!servicesEnabled) {
      await Geolocator.openAppSettings();
      return Future.error('Location services not enabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permission denied forever, we cannot access');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> getAddressFromLongLat(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemark);
    Placemark place = placemark[0];
    setState(() {
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    });
  }
}
