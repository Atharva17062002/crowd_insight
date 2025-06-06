import 'package:crowd_insight/screens/imp_info_screen.dart';
import 'package:crowd_insight/screens/owner_dashboard.dart';
import 'package:flag/flag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../utils/functions.dart';
import 'otp_screen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  ValueNotifier userCredential = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Welcome to Crowd Insight',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: ValueListenableBuilder(
    valueListenable: userCredential,
    builder: (context, value, child) {
         return Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Lottie.asset('assets/lottie.json'),
            ),
            const Center(
              child: Text(
                'Please enter your mobile number',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width * 0.5,
            //   child: const Text(
            //     'You\'ll receive a 6 digit code to verify next.',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //       fontSize: 15,
            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flag.fromCode(
                      FlagsCode.IN,
                      height: 30,
                      width: 30,
                    ),
                    Text(
                      '+91',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text('-', style: TextStyle(fontSize: 25)),
                    Container(
                        width: 200,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              phoneController.text = value;
                            });
                          },
                          decoration: new InputDecoration(
                              labelText: "Mobile Number",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        )),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: const BoxDecoration(color: Color(0xff2E3B62)),
              child: TextButton(
                onPressed: () {
                  print(phoneNumber);
                  // sendPhoneNumber();
                  // ap.isSignedIn == true
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ImportantInfoScreen()));
                  //     : sendPhoneNumber();
                },
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10,),

            const Row(
              children: [
                SizedBox(width: 20,),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('OR', style: TextStyle(fontSize: 20)),
                ),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 20,),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () async {
               userCredential.value =  await signInWithGoogle();
                if (userCredential.value != null){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OwnerDashboard(),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              icon: Image.asset(
                'assets/google.png',
                height: 24.0,
                width: 24.0,
              ),
              label: Text(
                'Sign in with Google',
                style: TextStyle(color: Colors.black),
              ),
            ),
            // SizedBox(height: MediaQuery.of(context).size.height*0.1,)
          ],
        );}
      ),
    );
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+91$phoneNumber");
    print(phoneNumber);
  }
}
