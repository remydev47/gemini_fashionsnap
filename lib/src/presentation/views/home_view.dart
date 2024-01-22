import 'dart:io';
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:stylesnap/src/presentation/widgets/imageupload_widget.dart';
import 'package:stylesnap/src/utils/constants.dart';
import 'package:stylesnap/src/utils/file_picker.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  File? _imageFile;

  String selectedOccasion = '';

  bool showErr = false;

  bool isAnalyzing = false;

  bool isPortraitPersonImage = false;

  void _selectedImage() async {
    final FilePickerResult? res = await pickImage();
    if (res != null) {
      setState(() {
        _imageFile = File(res.files.first.path!);
        showErr = false;
      });
    }
  }

  Widget _buildOccasionChip(String label) => ChoiceChip(
      label: Text(label),
      selected: selectedOccasion == label,
      onSelected: (bool selected) =>
          setState(() => selectedOccasion = selected ? label : ''));

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
              onPressed: _selectedImage,
              imageFile: _imageFile,
            ),
          ),
          Positioned(
            bottom: -12,
            right: 64,
            child: Container(
                height: 280,
                width: 280,
                decoration: BoxDecoration(
                    color: kPlatinumWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        bottomLeft: Radius.circular(32)))),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
                height: 320,
                width: 320,
                decoration: BoxDecoration(
                  color: kPlatinumWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      bottomLeft: Radius.circular(32)),
                )),
          )
        ],
      ),
    );
  }
}
