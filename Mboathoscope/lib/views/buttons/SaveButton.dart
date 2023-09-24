import 'package:flutter/material.dart';
import 'package:mboathoscope/themes/theme_extension.dart';
import 'package:mboathoscope/views/buttons/textButton.dart';

class SaveButton extends StatelessWidget {
  final String txt;
  final Function onPress;

  const SaveButton({
    super.key,
    required this.txt,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: flatButtonStyle,
      onPressed: () {
        onPress;
      },
      child: Text(
        txt,
        style: TextStyle(
          color: context.theme.primaryColor,
        ),
      ),
    );
  }
}
