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
        margin: EdgeInsets.only(top: 250.h, left: 60.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _welcomeText,
            _listOfDevicesText,
            _compatibleDevicesListView,
            _availableDevicesText,
            _availableDevicesDropdownButton,
            _reloadDevicesText,
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
          "Welcome to Parameters Reader",
          style: TextStyle(color: Colors.white, fontSize: 60.w),
          textAlign: TextAlign.center,
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

  // maybe change it to listview
  Widget get _availableDevicesDropdownButton => Container(
        margin: EdgeInsets.only(right: 350.w),
        alignment: Alignment.centerLeft,
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            dropdownValue,
            style: informationTextStyle.copyWith(color: Colors.white),
          ),
          elevation: 16,
          underline: Container(
            height: 2,
            color: UIColors.LIGHT_FONT_COLOR,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['Xiaomi MiBand 5', 'Bitalino']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black, fontSize: 40.w),
              ),
            );
          }).toList(),
        ),
      );

  Widget get _reloadDevicesText => _informationTextWrapper(
        'Reload available devices',
      );

  TextStyle get informationTextStyle =>
      TextStyle(color: UIColors.LIGHT_FONT_COLOR, fontSize: 40.w);

  Widget get _reloadButton => _buttonWrapper(() {}, 'Reload');

  Widget _buttonWrapper(Function onTap, String buttonText) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 40.h),
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
