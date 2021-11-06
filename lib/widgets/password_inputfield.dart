import 'package:biguenoexpress/components/pallete.dart';
import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  const PasswordInputField({
    Key key,
    @required this.icon,
    @required this.hint,
    this.inputType,
    this.inputAction,
    this.myController,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final myController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Container(
        height: size.height * 0.07,
        width: size.width,
        decoration: BoxDecoration(
            color: Colors.grey[500].withOpacity(0.5),
            borderRadius: BorderRadius.circular(16)
        ),
        child: Center(
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              hintText:  hint,
              hintStyle: kBodyText,
            ),
            obscureText: true,
            controller: myController,
            style: kBodyText,
            keyboardType: inputType,
            textInputAction: inputAction,
          ),
        ),
      ),
    );
  }
}
