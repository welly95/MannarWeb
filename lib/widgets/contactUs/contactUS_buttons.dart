import 'package:flutter/material.dart';

import '../../constants/styles.dart';

class ContactUSButton extends StatelessWidget {
  final Color? textColor;
  final String? buttonName;
  final IconData? buttonIcon;
  final Function()? onPressedFunction;

  ContactUSButton(
      {@required this.textColor,
      @required this.buttonName,
      @required this.buttonIcon,
      @required this.onPressedFunction});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(
        buttonIcon,
        color: textColor,
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      onPressed: onPressedFunction,
      label: Text(
        buttonName!,
        style: TextStyles.h3.copyWith(color: textColor),
      ),
    );
  }
}
