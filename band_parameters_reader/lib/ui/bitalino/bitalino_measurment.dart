import 'package:band_parameters_reader/data/bitalino_manager.dart';
import 'package:band_parameters_reader/models/measure.dart';
import 'package:band_parameters_reader/repositories/bitalino/bitalino_cubit.dart';
import 'package:band_parameters_reader/ui/bitalino/bitalino_measurment_summary.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BitalinoMeasurment extends StatefulWidget {
  final String address;

  const BitalinoMeasurment({Key key, this.address}) : super(key: key);

  @override
  _BitalinoMeasurmentState createState() => _BitalinoMeasurmentState();
}

class _BitalinoMeasurmentState extends State<BitalinoMeasurment> {
  int dropdownValue = 1;
  BitalinoManager manager;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      manager = BitalinoManager(context: context);
      manager.initialize(widget.address);
      Future.delayed(Duration(milliseconds: 300), () => manager.connectToDevice());
    });
  }

  Future<bool> isConnected() async {
    if (manager != null) {
      while (manager.connected() == false) {
        print("In loop");
        await Future.delayed(Duration(milliseconds: 100), () {});
      }
      return manager.connected();
    } else {
      await Future.delayed(Duration(milliseconds: 100), () {});
      await isConnected();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          backgroundColor: UIColors.GRADIENT_DARK_COLOR,
          title: Text(
            "Wykonywanie pomiaru Bitalino",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
          ),
        ),
        body: FutureBuilder(
            future: isConnected(),
            builder: (context, snap) {
              print(snap);
              if (snap.connectionState == ConnectionState.done) {
                if (manager.connected()) return _body();
                return Container();
              } else {
                return Container();
              }
            }));
  }

  Widget _body() {
    return Stack(children: [
      Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 80, top: 24),
          child: BlocBuilder<BitalinoCubit, BitalinoState>(
            builder: (context, state) => ListView(children: [
              _chartBuilder(state),
              SizedBox(height: 16),
              Row(children: [
                Expanded(child: _inputPicker()),
                SizedBox(width: 24),
                _pauseButton(state),
              ]),
              SizedBox(height: 24),
              _measures(state),
            ]),
          )),
      Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
              padding: const EdgeInsets.all(15),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    side: BorderSide(color: UIColors.GRADIENT_DARK_COLOR)),
                padding: const EdgeInsets.all(8),
                color: UIColors.GRADIENT_DARK_COLOR,
                onPressed: () {
                  pauseMeasure();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => BitalinoMeasurmentSummary()));
                },
                child: Text(
                  'Zakończ pomiar',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                ),
              )),
        ),
      ),
    ]);
  }

  Widget _chartBuilder(BitalinoState state) {
    List<Measure> measures;

    if (state.measure[dropdownValue - 1].length > 300) {
      measures = List<Measure>.from(state.measure[dropdownValue - 1].getRange(
          state.measure[dropdownValue - 1].length - 300,
          state.measure[dropdownValue - 1].length - 1));
    } else {
      measures = List<Measure>.from(state.measure[dropdownValue - 1]);
    }
    return Container(
      height: 500,
      width: double.infinity,
      child: Chart(
        data: measures,
      ),
    );
  }

  Widget _pauseButton(BitalinoState state) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: RaisedButton(
        onPressed: state.isCollectingData ? pauseMeasure : resumeMeasure,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(color: UIColors.GRADIENT_DARK_COLOR)),
        padding: const EdgeInsets.all(8),
        color: UIColors.GRADIENT_DARK_COLOR,
        child: Text(
          state.isCollectingData ? "Zatrzymaj" : "Wznów",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void pauseMeasure() {
    manager.stopAcquisition();
    context.bloc<BitalinoCubit>().pauseMeasure();
  }

  void resumeMeasure() {
    manager.startAcquisition();
    context.bloc<BitalinoCubit>().startMeasure();
  }

  Widget _measures(BitalinoState state) {
    List<Measure> measures = List<Measure>.from(state.measure[dropdownValue - 1]);
    var valueMax = 0;
    var valueMin = 0;
    int secondsElapsed = 0;
    if (measures.isNotEmpty) {
      secondsElapsed = measures.last.date.difference(measures.first.date).inSeconds;

      measures.sort((a, b) => a.measure.compareTo(b.measure));
      valueMax = measures.last.measure;
      valueMin = measures.first.measure;
    }

    return Column(
      children: [
        _textWithValue("Maksymalny pomiar", valueMax),
        SizedBox(height: 8),
        _textWithValue("Minimalny pomiar", valueMin),
        SizedBox(height: 8),
        _textWithValue(
            "Czas od pierwszego pomiaru", _printDuration(Duration(seconds: secondsElapsed))),
      ],
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _textWithValue(String text, var value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: _textStyle()),
        Text(
          value.toString(),
          style: _valueStyle(),
        )
      ],
    );
  }

  TextStyle _textStyle() {
    return TextStyle(color: UIColors.LIGHT_FONT_COLOR, fontSize: 17, fontWeight: FontWeight.w400);
  }

  TextStyle _valueStyle() {
    return TextStyle(
        color: UIColors.GRADIENT_DARK_COLOR, fontSize: 17, fontWeight: FontWeight.w700);
  }

  Widget _inputPicker() {
    return DropdownButton<int>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_drop_down),
      iconSize: 24,
      isExpanded: true,
      elevation: 16,
      style: TextStyle(color: Colors.black, fontSize: 16),
      underline: Container(
        height: 1.5,
        color: UIColors.GRADIENT_DARK_COLOR,
      ),
      onChanged: (int newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <int>[1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            "Wejście A${value}",
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}
