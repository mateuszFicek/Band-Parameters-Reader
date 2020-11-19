import 'package:band_parameters_reader/ui/main/bluetooth_devices.dart';
import 'package:band_parameters_reader/ui/main/bluetooth_l_e_widget.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BandParametersReaderHomePage extends StatefulWidget {
  const BandParametersReaderHomePage({Key key}) : super(key: key);

  @override
  _BandParametersReaderHomePageState createState() => _BandParametersReaderHomePageState();
}

class _BandParametersReaderHomePageState extends State<BandParametersReaderHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1080, height: 2340);
    return Scaffold(
        backgroundColor: UIColors.BACKGROUND_COLOR,
        appBar: AppBar(
          title: _welcomeText(),
          textTheme: GoogleFonts.nunitoSansTextTheme(
            Theme.of(context).textTheme,
          ),
          toolbarHeight: 180,
          backgroundColor: Colors.white,
          bottom: _bottomAppBar(),
          elevation: 0,
        ),
        body: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 32),
            child: _tabController.index == 0 ? BluetoothLEDevices() : BluetoothDevices()));
  }

  Widget _bottomAppBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 64),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Expanded(
              child: _segmentedControl(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBarText(String title, int index) {
    return Container(
      alignment: Alignment.center,
      child:
          Text(title, style: _tabController.index == index ? _activeTextStyle : _inactiveTextStyle),
      height: 40,
    );
  }

  TextStyle get _activeTextStyle =>
      TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 14);

  TextStyle get _inactiveTextStyle =>
      TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.black);

  Widget _segmentedControl() {
    return CupertinoSegmentedControl(
      selectedColor: UIColors.GRADIENT_DARK_COLOR,
      unselectedColor: UIColors.TILE_BACKGROUND_COLOR,
      borderColor: UIColors.GRADIENT_DARK_COLOR,
      onValueChanged: (int value) {
        _tabController.animateTo(value, duration: null, curve: null);
      },
      children: {
        0: _topBarText("Bluetooth LE", 0),
        1: _topBarText("Bluetooth", 1),
      },
      groupValue: _tabController.index,
    );
  }

  Widget _welcomeText() => Container(
        alignment: Alignment.centerLeft,
        child: Text(
          "Welcome to \nParameters Reader",
          style: TextStyle(color: Colors.black, fontSize: 80.w),
          textAlign: TextAlign.left,
        ),
      );
}
