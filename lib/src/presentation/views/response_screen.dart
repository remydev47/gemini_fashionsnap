import 'package:flutter/material.dart';
import 'package:stylesnap/src/utils/constants.dart';

class ResponseScreen extends StatelessWidget {
  final String response;
  const ResponseScreen({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kSilverGray,
          centerTitle: false,
          title: const Text(
            "Fashion snap",
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ).copyWith(top: MediaQuery.of(context).size.height * 0.13),
            child: ListTile(
              title: Text(
                response,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ));
  }
}
