import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/widgets/boxes/decoration_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LastSessionChart extends StatelessWidget {
  const LastSessionChart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340);
    return DecorationBox(
      child: Container(
        alignment: Alignment.center,
        child: Text(
          'PLACE CHART HERE',
          style: TextStyle(color: Colors.white),
        ),
      ),
      text: 'Last session',
    );
  }
}
