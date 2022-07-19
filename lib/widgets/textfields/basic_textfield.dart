import 'package:flutter/material.dart';
import '../../../constants/styles.dart';

class BasicTextField extends StatefulWidget {
  final ValueKey<String?> key;
  final TextEditingController basicTextController;
  final String hintText;
  final TextInputType inputType;
  final String? Function(String?)? validator;

  BasicTextField(this.key, this.basicTextController, this.hintText, this.inputType, this.validator);

  @override
  State<BasicTextField> createState() => _BasicTextFieldState();
}

class _BasicTextFieldState extends State<BasicTextField> {
  @override
  void initState() {
    widget.basicTextController.addListener(() {
      print(widget.basicTextController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.basicTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: widget.basicTextController,
        onFieldSubmitted: (value) {
          widget.basicTextController.text = value;
          print(widget.basicTextController.text);
        },
        validator: widget.validator,
        keyboardType: widget.inputType,
        autocorrect: false,
        style: TextStyles.body,
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
          hintText: widget.hintText,
          hintStyle: TextStyles.textFieldsHint,
          label: Text(widget.hintText),
          labelStyle: TextStyles.textFieldsHint,
          alignLabelWithHint: true,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}
