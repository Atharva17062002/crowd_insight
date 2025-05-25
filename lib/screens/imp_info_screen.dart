import 'dart:io';

import 'package:crowd_insight/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../main.dart';
import '../utils/utils.dart';

class ImportantInfoScreen extends StatefulWidget {
  const ImportantInfoScreen({super.key});

  @override
  State<ImportantInfoScreen> createState() => _ImportantInfoScreenState();
}

class _ImportantInfoScreenState extends State<ImportantInfoScreen> {
  late double lat, lng, speed;
  late String dateString;
  Web3Client? ethClient;
  Client? httpClient;

  @override
  void initState() {
    super.initState();
    // Initialize location and listen for location changes
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient!);
    Location().onLocationChanged.listen((res) {
      setState(() {
        lat = res.latitude!;
        lng = res.longitude!;
        // speed = res.speed!;
      });
      print(lat);
      print(lng);
      // Call the method to insert data to Firestore
      // insertDataToFirestore();
    });
  }
  //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   httpClient!.close();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Important Information'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Important Notice',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Please submit accurate and respectful location data through CrowdInsight. Your responsible contributions are essential for generating meaningful insights and upholding user privacy. Thank you for your cooperation and support!',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Date: May 17, 2024',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Location: Somewhere important',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Provider.of<CoordinateData>(context, listen: false).coordinates.add([lat.toString(), lng.toString()]);
                addLocation(lat.toString(), lng.toString(), '5', ethClient!);
                showSnackBar(context, 'Location sent successfully');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                'Send Location',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
