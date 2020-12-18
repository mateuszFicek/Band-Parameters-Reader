import 'package:band_parameters_reader/data/bitalino_manager.dart';
import 'package:band_parameters_reader/models/measure.dart';
import 'package:band_parameters_reader/repositories/bitalino_cubit.dart';
import 'package:band_parameters_reader/ui/bitalino/bitalino_measurment_summary.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BitalinoMeasurment extends StatefulWidget {
  final BitalinoManager manager;

  const BitalinoMeasurment({Key key, this.manager}) : super(key: key);

  @override
  _BitalinoMeasurmentState createState() => _BitalinoMeasurmentState();
}

class _BitalinoMeasurmentState extends State<BitalinoMeasurment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          centerTitle: true,
          backgroundColor: UIColors.GRADIENT_DARK_COLOR,
          title: Text(
            "Wykonywanie pomiaru Bitalino",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
          ),
        ),
        body: Stack(children: [
          Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 80, top: 24),
              child: BlocBuilder<BitalinoCubit, BitalinoState>(
                builder: (context, state) => ListView(children: [
                  _chartBuilder(state),
                  SizedBox(height: 16),
                  Row(children: [
                    Spacer(),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BitalinoMeasurmentSummary()));
                    },
                    child: Text(
                      'Zakończ pomiar',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  )),
            ),
          ),
        ]));
  }

  Widget _chartBuilder(BitalinoState state) {
    List<Measure> measures;

    if (state.measure.length > 300) {
      measures = List<Measure>.from(state.measure
          .getRange(state.measure.length - 300, state.measure.length - 1));
    } else {
      measures = List<Measure>.from(state.measure);
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
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void pauseMeasure() {
    widget.manager.stopAcquisition();
    context.bloc<BitalinoCubit>().pauseMeasure();
  }

  void resumeMeasure() {
    widget.manager.startAcquisition();
    context.bloc<BitalinoCubit>().startMeasure();
  }

  Widget _measures(BitalinoState state) {
    List<Measure> measures = List<Measure>.from(state.measure);
    var valueMax = 0;
    var valueMin = 0;
    int secondsElapsed = 0;
    if (measures.isNotEmpty) {
      secondsElapsed =
          measures.last.date.difference(measures.first.date).inSeconds;

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
        _textWithValue("Czas od pierwszego pomiaru", secondsElapsed),
      ],
    );
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
    return TextStyle(
        color: UIColors.LIGHT_FONT_COLOR,
        fontSize: 17,
        fontWeight: FontWeight.w400);
  }

  TextStyle _valueStyle() {
    return TextStyle(
        color: UIColors.GRADIENT_DARK_COLOR,
        fontSize: 17,
        fontWeight: FontWeight.w700);
  }
}
