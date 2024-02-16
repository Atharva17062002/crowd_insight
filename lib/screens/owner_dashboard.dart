import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

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
  String TextBoxValue = "";

  @override
  void initState() {
    super.initState();
    // Initialize location and listen for location changes
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
  }

  Future<void> _getLocation() async {
    final location = await getLocation('2', ethClient!);
    setState(() {
      userLocation = location;
      TextBoxValue = userLocation.toString();

    });
  }

  Future<void> _getAllLocations() async {
    final locations = await getAllLocations(ethClient!);
    setState(() {
      allLocations = locations;
      TextBoxValue = allLocations.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text( TextBoxValue,
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text(
                'Get Location',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
            ElevatedButton(
              onPressed: _getAllLocations,
              child: const Text(
                'Get All Locations',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add functionality for the 'View' button if needed
              },
              child: const Text(
                'View',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
