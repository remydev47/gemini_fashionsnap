import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageUploadScreenWidget extends StatelessWidget {
  final VoidCallback _onPressed;
  final File? _imageFile;

  const ImageUploadScreenWidget({
    super.key,
    required VoidCallback onPressed,
    required File imageFile,
  })  : _onPressed = onPressed,
        _imageFile = imageFile;

  @override
  Widget build(BuildContext context) {
    return _imageFile != null
        ? Image.file(_imageFile!, fit: BoxFit.cover)
        : Padding(
            padding: const EdgeInsets.all(20.0)
                .copyWith(bottom: MediaQuery.of(context).size.height * 0.2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: _onPressed,
                    icon: const Icon(CupertinoIcons.camera)),
                Text("Upload a picture (full body for best results",
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          );
  }
}
