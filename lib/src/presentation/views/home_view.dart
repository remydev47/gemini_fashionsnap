import 'dart:io';
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:stylesnap/src/presentation/views/response_screen.dart';
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

  bool showError = false;

  bool isAnalyzing = false;

  bool isPortraitPersonImage = false;

  final gemini = Gemini.instance;

  void _selectedImage() async {
    final FilePickerResult? res = await pickImage();
    if (res != null) {
      setState(() {
        _imageFile = File(res.files.first.path!);
        showError = false;
      });
    }
  }

  Future<String> imageAnalyzer(String text, File image) async {
    String result = '';
    setState(() => isAnalyzing = true);
    await gemini.textAndImage(
        text: text, images: [image.readAsBytesSync()]).then((value) {
      setState(() {
        result = value!.content!.parts![0].text!;
        isAnalyzing = false;
      });
      return result;
    }).catchError((e) {
      setState(() => isAnalyzing = false);
      log('textAndImageInput', error: e);
      return result;
    });

    return result;
  }

  void startAnalyzing() async {
    if (selectedOccasion.isEmpty || _imageFile == null || isAnalyzing) {
      setState(() => showError = true);
      return;
    }
    bool containsPerson = await containsSingleOrPortraitPerson(_imageFile!);
    if (!containsPerson) {
      setState(() {
        showError = true;
        _imageFile = null;
      });
      return;
    } else {
      setState(() => showError = false);

      String res = await imageAnalyzer(
          "Analyze my outfit in this picture and tell some clothing styles and necessary adjustment that should be made to enhance my current style for $selectedOccasion look",
          _imageFile!);
      setState(() => _imageFile = null);
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResponseScreen(response: res)));
      }
    }
  }

  Widget buildOccasionChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: selectedOccasion == label,
      onSelected: (selected) {
        setState(() {
          selectedOccasion = selected ? label : '';
        });
      },
    );
  }

  Future<bool> containsSingleOrPortraitPerson(File imageFile) async {
    final result = await imageAnalyzer(
        "Analyze the image and determine if there is exactly one visible human figure present. Return TRUE if only one person is detected, and FALSE otherwise",
        imageFile);
    if (result.contains("TRUE")) {
      setState(() => isPortraitPersonImage = true);
    } else {
      setState(() => isPortraitPersonImage = false);
    }
    return isPortraitPersonImage;
  }

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
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'What occasion is this outfit for?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: [
                      buildOccasionChip('Casual'),
                      buildOccasionChip('Formal'),
                      buildOccasionChip('Work'),
                    ],
                  ),
                  if (showError) const SizedBox(height: 16),
                  if (showError)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: const BoxDecoration(color: kWhite),
                      child: Text(
                        'Please select an occasion and upload an image.',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: kErrorColor),
                      ),
                    ),
                  if (isAnalyzing) SizedBox(height: 16),
                  Padding(padding: EdgeInsets.all(10)),
                  if (isAnalyzing) CircularProgressIndicator(),
                  SizedBox(height: 16),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: isAnalyzing ? null : startAnalyzing,
                    child: const Text("Start Analyzer"),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
