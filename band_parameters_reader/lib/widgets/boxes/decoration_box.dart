import 'package:band_parameters_reader/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DecorationBox extends StatelessWidget {
  const DecorationBox({Key key, this.child, this.text = ''}) : super(key: key);
  final Widget child;
  final String text;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340);

    return Container(
      height: MediaQuery.of(context).size.width / 2,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 60.w),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              UIColors.GRADIENT_LIGHT_COLOR,
              UIColors.GRADIENT_DARK_COLOR
            ],
          ),
          borderRadius: BorderRadius.circular(40.w)),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(top: 40.w, left: 40.w),
              child: Text(
                text,
                style: GoogleFonts.montserratAlternates(
                    color: Colors.white, fontSize: 50.w),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
