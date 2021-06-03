import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'modalBottomSheet.dart';

class PickUserImage extends StatefulWidget {
  final void Function(File pickedImage) sendImageData;
  final String initialValue;
  PickUserImage(this.sendImageData, {this.initialValue});

  @override
  _PickUserImageState createState() => _PickUserImageState();
}

class _PickUserImageState extends State<PickUserImage> {
  File _pickedImage;
  String initialValue;

  void initState() {
    super.initState();
    if (widget.initialValue != null) this.initialValue = widget.initialValue;
  }

  void _pickAndFormatImage() async {
    final picker = ImagePicker();

    ImageSource imageSource = ImageSource.camera;
    
    if (imageSource == null) return;

    final pickedImage = await picker.getImage(
      source: imageSource,
    );
    if (pickedImage == null) return;
    final pickedImageFile = File(pickedImage.path);
    File croppedFile = await cropUserSelectedImage(pickedImageFile.path);

    if (croppedFile == null) return;
    setState(() {
      _pickedImage = croppedFile;
    });
    widget.sendImageData(_pickedImage);
  }

  Future<File> cropUserSelectedImage(String path) async =>
      await ImageCropper.cropImage(
          maxHeight: 250,
          maxWidth: 250,
          compressQuality: 80,
          sourcePath: path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Recorte sua imagem',
              toolbarColor: Theme.of(context).primaryColor,
              toolbarWidgetColor: Theme.of(context).accentColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

  @override
  Widget build(BuildContext context) {
    return Container(
          child: Column(children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey,
          backgroundImage: buildImage(),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton(
              onPressed: _pickAndFormatImage,
              child: Text('Selecionar Imagem')),
        )
      ]),
    );
  }

  ImageProvider buildImage() {
    if (_pickedImage != null)
      return FileImage(_pickedImage);
    else if (_pickedImage != null)
      return NetworkImage(initialValue);
    return null;
  }
}
