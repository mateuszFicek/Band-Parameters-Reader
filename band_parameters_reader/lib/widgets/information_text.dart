import 'package:band_parameters_reader/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InformationText extends StatelessWidget {
  const InformationText({Key key, this.text}) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340);

    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 60.h),
      child: Text(
        text,
        style: informationTextStyle,
      ),
    );
  }

  TextStyle get informationTextStyle =>
      TextStyle(color: UIColors.LIGHT_FONT_COLOR, fontSize: 50.w);
}
