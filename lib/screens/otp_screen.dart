import 'package:crowd_insight/screens/imp_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:crowd_insight/utils/utils.dart';

import '../provider/auth_provider.dart';


class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? Otp;
  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                AntDesign.arrowleft,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: SafeArea(
        child: isLoading == true ? const Center(child: CircularProgressIndicator(
          color: Color(0xff2E3B62),
        ),):Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            const Center(
              child: Text(
                'Verify Phone',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                'Code is sent to ${widget.phoneNumber}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Pinput(
              length: 6,
              showCursor: true,
              onCompleted: (value){
                setState(() {
                  Otp = value;
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: const Text(
                    'Didn\'t receive the code?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Request Again',
                      style: TextStyle(color: Color(0xff061D28)),
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: const BoxDecoration(color: Color(0xff2E3B62)),
                child: TextButton(
                    onPressed: () {
                      if(Otp != null){
                        verifyOtp(context, Otp!);
                      }else {
                        showSnackBar(context, "Enter 6-Digit Code");
                      }
                    },
                    child: const Text(
                      'VERIFY AND CONTINUE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ))),
          ],
        ),
      ),
    );
  }
  void verifyOtp(BuildContext context, String otp){
    print(otp);
    final ap = Provider.of<AuthProvider>(context,  listen: false);
    ap.verifyOtp(context: context, verificationId: widget.verificationId, userOtp: otp, onSuccess: (){
      ap.checkExistingUser().then((value)async{
        print(value);
        if (value == true){
          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> const ImportantInfoScreen()), (route) => true);
        }else{
          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> const ImportantInfoScreen()), (route) => false);
        }
      });
    });
  }
}
