import 'package:flutter/material.dart';
import '../../../constants/styles.dart';

class DescriptionTextField extends StatelessWidget {
  final ValueKey<String?> key;
  final TextEditingController basicTextController;
  final String hintText;
  final TextInputType inputType;
  final String? Function(String?)? validator;

  DescriptionTextField(this.key, this.basicTextController, this.hintText, this.inputType, this.validator);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: basicTextController,
        // onChanged: (value) {
        //   basicTextController.text = value;
        // },
        maxLines: 4,
        validator: validator,
        keyboardType: inputType,
        autocorrect: false,
        style: TextStyles.body, textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10),
          ),
          fillColor: Colors.white70,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyles.textFieldsHint,
          label: Text(hintText),
          labelStyle: TextStyles.textFieldsHint,
          alignLabelWithHint: true,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}
