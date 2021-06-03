import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ModalBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      height: deviceSize.height / 7,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                          child: IconButtonWithText(
                  () => Navigator.of(context).pop(ImageSource.gallery),
                  Icons.image,
                  'Galeria'),
            ),
            SizedBox(
              width: deviceSize.width / 5,
            ),
            Flexible(
                          child: IconButtonWithText(
                  () => Navigator.of(context).pop(ImageSource.camera),
                  Icons.camera,
                  'Tirar foto'),
            )
          ],
        ),
      ),
    );
  }
}

class IconButtonWithText extends StatelessWidget {
  const IconButtonWithText(
    this.onTap,
    this.icon,
    this.text,
  );

  final Function onTap;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.onTap();
      },
      child: Container(
              child: Column(children: [
          Expanded(child: CircleAvatar(child: Icon(this.icon))),
          const SizedBox(
            height: 10,
          ),
          Text(
            this.text,
            style: Theme.of(context).textTheme.headline1,
          )
        ]),
      ),
    );
  }
}
