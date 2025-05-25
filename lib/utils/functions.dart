import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'utils.dart';
import 'location_model.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contract_address;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'CrowdSense'),
      EthereumAddress.fromHex(contractAddress));

  return contract;
}

Future<String> callFunction(String funcname, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(funcname);

  try {
    final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
        ),
        chainId: null,
        fetchChainIdFromNetworkId: true);
    return result;
  } catch (e) {
    return e.toString();
  }
}



Future<List<dynamic>> getLocation(String userId, Web3Client ethClient) async {
  try {

    var result = await ask('getLocation', [userId], ethClient);
    print(result);

    if (result.isNotEmpty) {
      return result;
      // Map<String, dynamic> locationDataMap = result[0];
      // return LocationData.fromMap(locationDataMap);
    } else {
      throw Exception('Location not found for user $userId');
    }
  } catch (e) {
    print('Error fetching location: $e');
    rethrow;
  }
}

Future<List<List<dynamic>>> getAllLocations(Web3Client ethClient) async {
  try {
    final contract = await loadContract();
    final ethFunction = contract.function('getAllLocation');

    final result = await ask('getAllLocation', [], ethClient);

    List<List<dynamic>> allLocations = [];

    for (var userLocationList in result) {
      List<List<dynamic>> locations = [];
      for (var locationData in userLocationList) {
        print(locationData);
        allLocations.add(locationData);
        // Map<String, dynamic> locationDataMap = Map<String, dynamic>.from(locationData);
        // locations.add(LocationData.fromMap(locationDataMap));
      }

      // allLocations.add(locations);

    }
    // print(result);
    // print(result.runtimeType);
    
    // print(allLocations);
    return allLocations;
  } catch (e) {
    print('Error fetching all locations: $e');
    rethrow;
  }
}


Future <List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result =
  ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

class LocationData {
  final String user_id;
  final String latitude;
  final String longitude;
  final int timestamp;

  LocationData(this.user_id, this.latitude, this.longitude, this.timestamp);

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp
    };
  }

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
        map['user_id'], map['latitude'], map['longitude'], map['timestamp']);
  }

  String toJson() => json.encode(toMap());
}

Future<String> addLocation(
    String latitude, String longitude, String id, Web3Client ethClient) async {
  try {
    var response = await callFunction(
        'addLocation', [id, latitude, longitude], ethClient, owner_private_key);
    print('Location sent successfully');
    return response;
  } catch (e) {
    print(e);
    return e.toString();
  }
}

Future<dynamic> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  } on Exception catch (e) {
    // TODO
    print('exception->$e');
  }
}

Future<bool> signOutFromGoogle() async {
  try {
    await FirebaseAuth.instance.signOut();
    return true;
  } on Exception catch (_) {
    return false;
  }
}