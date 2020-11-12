import 'package:band_parameters_reader/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SquareBox extends StatelessWidget {
  const SquareBox({Key key, this.child, this.text = ''}) : super(key: key);
  final Widget child;
  final String text;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340);

    return Container(
      height: MediaQuery.of(context).size.width / 2 - 90.w,
      width: MediaQuery.of(context).size.width / 2 - 90.w,
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(40.w),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(top: 40.w, left: 40.w),
                child: Text(
                  text,
                  style: GoogleFonts.montserratAlternates(
                      color: Colors.white, fontSize: 40.w),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(40.w),
                height: MediaQuery.of(context).size.width / 2 - 180.w,
                alignment: Alignment(0, -0.25),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
