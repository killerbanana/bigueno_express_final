import 'package:biguenoexpress/components/pallete.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key key, this.btnText, this.press,
  }) : super(key: key);
  final String btnText;
  final Function press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: size.height * 0.07,
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.blueAccent
        ),
        child: TextButton(
          onPressed: press,
          child: Text(
              btnText,
              style: kBodyText
          ),
        ),
      ),
    );
  }
}