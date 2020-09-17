import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BandParametersReaderHomePage extends StatefulWidget {
  const BandParametersReaderHomePage({Key key}) : super(key: key);

  @override
  _BandParametersReaderHomePageState createState() =>
      _BandParametersReaderHomePageState();
}

class _BandParametersReaderHomePageState
    extends State<BandParametersReaderHomePage> {
  String dropdownValue = 'Bitalino';

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340);
    return Scaffold(
      backgroundColor: UIColors.BACKGROUND_COLOR,
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 250.h, horizontal: 60.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _welcomeText,
            _listOfDevicesText,
            _compatibleDevicesListView,
            _availableDevicesText,
            _availableDevicesListView,
            _reloadButton,
          ],
        ),
      ),
    );
  }

  Widget _informationTextWrapper(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 60.h),
      child: Text(
        text,
        style: informationTextStyle,
      ),
    );
  }

  Widget get _welcomeText => Container(
        alignment: Alignment.centerLeft,
        child: Text(
          "Welcome to \nParameters Reader",
          style: TextStyle(color: Colors.white, fontSize: 60.w),
          textAlign: TextAlign.left,
        ),
      );

  Widget get _listOfDevicesText =>
      _informationTextWrapper('List of compatible devices:');

  Widget get _compatibleDevicesListView => Container(
        height: 70.h * Constants.COMPATIBLE_DEVICES.length,
        child: ListView.builder(
            padding: EdgeInsets.all(20.w),
            itemCount: Constants.COMPATIBLE_DEVICES.length,
            itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(bottom: 10.h),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Constants.COMPATIBLE_DEVICES[index],
                    style: TextStyle(color: Colors.white, fontSize: 30.w),
                  ),
                )),
      );

  Widget get _availableDevicesText => _informationTextWrapper(
        'Choose your device from available:',
      );

  Widget get _availableDevicesListView => Container(
        alignment: Alignment.centerLeft,
        height: 1200.h,
        child: ListView.builder(
            itemBuilder: (context, index) => Container(
                  height: 150.h,
                  child: Column(
                    children: [
                      Text(
                        Constants.FOUND_DEVICES_MOC.keys.elementAt(index),
                        style: informationTextStyle.copyWith(fontSize: 40.w),
                      ),
                      Text(Constants.FOUND_DEVICES_MOC.values.elementAt(index),
                          style:
                              TextStyle(color: Colors.white, fontSize: 30.w)),
                    ],
                  ),
                ),
            itemCount: Constants.FOUND_DEVICES_MOC.length),
      );

  TextStyle get informationTextStyle =>
      TextStyle(color: UIColors.LIGHT_FONT_COLOR, fontSize: 40.w);

  Widget get _reloadButton => _buttonWrapper(() {}, 'Reload Devices');

  Widget _buttonWrapper(Function onTap, String buttonText) {
    return Container(
      alignment: Alignment.center,
      child: Material(
        color: UIColors.LIGHT_FONT_COLOR,
        borderRadius: BorderRadius.circular(40.w),
        child: InkWell(
          splashColor: UIColors.BACKGROUND_COLOR.withOpacity(0.2),
          onTap: onTap,
          borderRadius: BorderRadius.circular(40.w),
          child: Container(
            width: 400.w,
            height: 100.h,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(40.w)),
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: _buttonTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  TextStyle get _buttonTextStyle =>
      TextStyle(color: Colors.black, fontSize: 40.w);
}
