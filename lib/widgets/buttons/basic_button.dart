import 'package:flutter/material.dart';

import '../../constants/styles.dart';

class BasicButton extends StatelessWidget {
  final String? buttonName;
  final Function()? onPressedFunction;

  BasicButton({@required this.buttonName, @required this.onPressedFunction});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Color(0xFF03564C),
      ),
      onPressed: onPressedFunction!,
      child: Text(
        buttonName!,
        style: TextStyles.h1,
      ),
    );
  }
}
