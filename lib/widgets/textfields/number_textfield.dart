import 'package:flutter/material.dart';
import '../../../constants/styles.dart';

class NumberTextField extends StatelessWidget {
  final ValueKey<String?> key;
  final TextEditingController numberTextController;
  final String hintText;
  final String? Function(String?) validator;

  NumberTextField(this.key, this.numberTextController, this.hintText, this.validator);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        key: key,
        controller: numberTextController,
        // onChanged: (value) {
        //   numberTextController.text = value;
        // },
        validator: validator,
        keyboardType: TextInputType.phone,
        style: TextStyles.elMessiri,
        textDirection: TextDirection.ltr,
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
