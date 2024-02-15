import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String infura_url = "https://goerli.infura.io/v3/2b5b6fbf7d764cfea27b6e341e69ad09";



void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
