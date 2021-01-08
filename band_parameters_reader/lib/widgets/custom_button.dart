import 'package:band_parameters_reader/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function() onPressed;
  final String text;
  final bool isPassive;
  final Color activeColor;
  final bool padded;

  const CustomButton(
      {@required this.text,
      @required this.onPressed,
      this.isPassive = true,
      this.activeColor = UIColors.GRADIENT_DARK_COLOR,
      this.padded = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padded ? EdgeInsets.only(left: 16.0, right: 16, bottom: 16) : EdgeInsets.all(0.0),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: RaisedButton(
            elevation: 0,
            color: isPassive ? Colors.white : activeColor,
            textColor: isPassive ? activeColor : Colors.white,
            disabledColor: UIColors.LIGHT_FONT_COLOR,
            disabledTextColor: Colors.white,
            child: Text(text, style: TextStyle(fontSize: 16)),
            onPressed: onPressed,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  color: activeColor,
                ))),
      ),
    );
  }
}
