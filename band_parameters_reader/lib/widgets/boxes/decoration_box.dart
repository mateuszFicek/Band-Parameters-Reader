import 'package:band_parameters_reader/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DecorationBox extends StatelessWidget {
  const DecorationBox(
      {Key key,
      this.child,
      this.text = '',
      this.backgroundColor,
      this.heightScale = 2})
      : super(key: key);
  final Widget child;
  final String text;
  final Color backgroundColor;
  final int heightScale;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340);

    return Container(
      height: MediaQuery.of(context).size.width / heightScale,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 60.w),
      padding: EdgeInsets.all(40.w),
      decoration: BoxDecoration(
          border: Border.all(
            color: UIColors.LIGHT_FONT_COLOR,
            width: 1.0,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor == null ? Colors.white : backgroundColor,
              backgroundColor == null ? Colors.white : backgroundColor,
            ],
          ),
          borderRadius: BorderRadius.circular(40.w)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              child: Text(
                text,
                style: GoogleFonts.montserratAlternates(
                    color: Colors.black, fontSize: 50.w),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
