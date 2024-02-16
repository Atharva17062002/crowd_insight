import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String infura_url = "https://goerli.infura.io/v3/2b5b6fbf7d764cfea27b6e341e69ad09";

String owner_private_key = "b6f531402f728e4d178715dcf04aa3fd44b84032bbffc1b7d7e91b9fd5e1e26c";

String user_private_key = "54528c0d333d666c857d8911c9f8b93c66a37eca7c5d402da83f3e2492d4a4b9";

String contract_address = "0x0C7d6488Fc0214e5Ae86110a56B81aC15488DEE0";

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
