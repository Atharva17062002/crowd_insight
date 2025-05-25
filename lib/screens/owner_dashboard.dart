import 'package:crowd_insight/screens/imp_info_screen.dart';
import 'package:crowd_insight/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../main.dart';
import '../utils/functions.dart';
import '../utils/utils.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({Key? key}) : super(key: key);

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  Web3Client? ethClient;
  Client? httpClient;
  List<List<dynamic>> allLocations = [];
  List<dynamic> userLocation = [];
  String TextBoxValue = "21.1112058,56.8861138";

  @override
  void initState() {
    super.initState();
    // Initialize location and listen for location changes
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
  }

  Future<void> _getLocation(List<List<String>> coordinates) async {
    // final location = await getLocation('2', ethClient!);
    setState(() {
      userLocation = coordinates.last;
      TextBoxValue = userLocation.toString();
    });
  }

  Future<void> _getAllLocations(List<List<String>> coordinates) async {
    // final locations = await getAllLocations(ethClient!);
    setState(() {
      allLocations = coordinates;
      TextBoxValue = allLocations.toString();
    });
  }

  List<LatLng> convertToLatLng(List<dynamic> inputList) {
    List<LatLng> result = [];
    for (var item in inputList) {
      // var coordinates = item[0];
      double lat = double.tryParse(item[1]) ?? 0.0;
      double lng = double.tryParse(item[2]) ?? 0.0;
      result.add(LatLng(lat, lng));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> coordinates =
        Provider.of<CoordinateData>(context).coordinates;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 400,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    TextBoxValue,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ImportantInfoScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'User Page',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _getAllLocations(coordinates);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Get All Locations',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _getLocation(coordinates);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Get Location of current user',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(userLocation);
                var result = convertToLatLng(userLocation);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(locations: result),
                  ),
                );
              },
              child: const Text(
                'Show locations on map',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
