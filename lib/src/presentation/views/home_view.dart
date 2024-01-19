import 'package:flutter/material.dart';
import 'package:stylesnap/src/presentation/widgets/imageupload_widget.dart';
import 'package:stylesnap/src/utils/constants.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override

  Widget build(BuildContext context) {
    
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: kSilverGray.withOpacity(0.8),
        centerTitle: false,
        title: Text(
          "StyleSnap",
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: size.height,
            child: ImageUploadScreenWidget(
              onPressed: () {},
              imageFile: ,
            ),
          ),
        ],
      ),
    );
  }
}
