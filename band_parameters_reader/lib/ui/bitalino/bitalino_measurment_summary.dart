import 'dart:io';

import 'package:band_parameters_reader/models/measure.dart';
import 'package:band_parameters_reader/repositories/bitalino/bitalino_cubit.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/widgets/chart.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BitalinoMeasurmentSummary extends StatefulWidget {
  @override
  _BitalinoMeasurmentSummaryState createState() => _BitalinoMeasurmentSummaryState();
}

class _BitalinoMeasurmentSummaryState extends State<BitalinoMeasurmentSummary> {
  String measurmentTitle;
  TextEditingController _textEditingController = TextEditingController();
  File file;
  int dropdownValue = 1;
  SfRangeValues _values;
  bool first = false;
  bool second = false;
  bool third = false;
  bool fourth = false;

  @override
  void initState() {
    super.initState();
    initTitle();
    initRange();
  }

  void initTitle() {
    String dateFormatted = DateFormat('yyyy_MM_dd_kk_mm').format(DateTime.now());
    measurmentTitle = "pomiar_$dateFormatted";
  }

  void initRange() {
    Future.delayed(Duration.zero, () {
      if (context.bloc<BitalinoCubit>().state.measure[0].length.toDouble() < 2000)
        _values =
            SfRangeValues(0.0, context.bloc<BitalinoCubit>().state.measure[0].length.toDouble());
      else
        _values = SfRangeValues(0.0, 2000.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: UIColors.GRADIENT_DARK_COLOR,
        title: Text(
          measurmentTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 130, left: 15, right: 15, top: 24),
            child: ListView(
              children: [
                _chartBuilder(),
                _slider(),
                SizedBox(height: 16),
                _inputPicker(),
                SizedBox(height: 24),
                Text("Generuj plik dla wejść: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                _checkboxes(),
                _titleInput(),
                SizedBox(height: 16),
              ],
            ),
          ),
          _buttons()
        ],
      ),
    );
  }

  Widget _slider() {
    return BlocBuilder<BitalinoCubit, BitalinoState>(builder: (_, state) {
      return Container(
          height: 50,
          width: double.infinity,
          child: SfRangeSlider(
            activeColor: Color(0xFFDCD8FD),
            min: 0.0,
            max: state.measure[0].length.toDouble(),
            values: _values,
            interval: (state.measure[0].length / 8).roundToDouble(),
            stepSize: 1,
            showTicks: true,
            showLabels: true,
            enableTooltip: true,
            minorTicksPerInterval: 1,
            onChanged: (SfRangeValues values) {
              setState(() {
                if (values.end != _values.end && values.end - values.start > 2000)
                  _values = SfRangeValues(values.end - 2000, values.end);
                else if (values.start != _values.start && values.end - values.start > 2000)
                  _values = SfRangeValues(values.start, values.start+2000);
                else
                  _values = values;
              });
            },
          ));
    });
  }

  Widget _chartBuilder() {
    List<Measure> measures;
    return BlocBuilder<BitalinoCubit, BitalinoState>(builder: (_, state) {
      if (_values == null) {
        if (context.bloc<BitalinoCubit>().state.measure[0].length.toDouble() < 2000)
          _values =
              SfRangeValues(0.0, context.bloc<BitalinoCubit>().state.measure[0].length.toDouble());
        else
          _values = SfRangeValues(0.0, 2000.0);
      }
      measures = List<Measure>.from(state.measure[dropdownValue - 1]
          .getRange((_values.start as double).round(), (_values.end as double).round()));

      return Container(
          height: 450,
          width: double.infinity,
          child: Chart(
            data: measures,
            canZoom: true,
          ));
    });
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

  Widget _checkboxes() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Checkbox(
              activeColor: Color(0xFF6151F6),
              value: first,
              onChanged: (value) {
                setState(() {
                  first = value;
                });
              }),
          Text("A1"),
        ]),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Checkbox(
              activeColor: Color(0xFF6151F6),
              value: second,
              onChanged: (value) {
                setState(() {
                  second = value;
                });
              }),
          Text("A2"),
        ]),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Checkbox(
              activeColor: Color(0xFF6151F6),
              value: third,
              onChanged: (value) {
                setState(() {
                  third = value;
                });
              }),
          Text("A3"),
        ]),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Checkbox(
              activeColor: Color(0xFF6151F6),
              value: fourth,
              onChanged: (value) {
                setState(() {
                  fourth = value;
                });
              }),
          Text("A4"),
        ]),
      ],
    );
  }

  Widget _titleInput() {
    return TextField(
      controller: _textEditingController,
      onSubmitted: (text) {
        setState(() {
          if (text.length == 0)
            initTitle();
          else
            measurmentTitle = text;
        });
      },
      decoration: InputDecoration(
        hintText: "Nazwa pliku",
      ),
    );
  }

  Widget _buttons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [saveAndShareButton(), _endButton()],
      ),
    );
  }

  Widget _endButton() {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: SizedBox(
          width: double.infinity,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: BorderSide(color: UIColors.GRADIENT_DARK_COLOR)),
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text(
              'Wyjdź do ekranu głównego',
              style: TextStyle(
                  color: UIColors.GRADIENT_DARK_COLOR, fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ));
  }

  Widget saveAndShareButton() {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    side: BorderSide(color: UIColors.GRADIENT_DARK_COLOR)),
                padding: const EdgeInsets.all(8),
                color: UIColors.GRADIENT_DARK_COLOR,
                onPressed: () {
                  getCsv();
                },
                child: Text('Zapisz plik i udostępnij',
                    style: TextStyle(
                        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)))));
  }

  getCsv() async {
    final start = DateTime.now();
    String filePath;
    List<Measure> measure1 = context.bloc<BitalinoCubit>().state.measure[0];
    List<Measure> measure2 = context.bloc<BitalinoCubit>().state.measure[1];
    List<Measure> measure3 = context.bloc<BitalinoCubit>().state.measure[2];
    List<Measure> measure4 = context.bloc<BitalinoCubit>().state.measure[3];

    List<List<dynamic>> rows = List<List<dynamic>>();
    List<dynamic> row = List();
    row.add("Id");
    if (first) row.add("Pomiar 1");
    if (second) row.add("Pomiar 2");
    if (third) row.add("Pomiar 3");
    if (fourth) row.add("Pomiar 4");
    row.add("Data");
    rows.add(row);
    for (int i = 0; i < measure1.length; i++) {
      List<dynamic> row = List();
      row.add(measure1[i].id);
      if (first) row.add(measure1[i].measure);
      if (second) row.add(measure2[i].measure);
      if (third) row.add(measure3[i].measure);
      if (fourth) row.add(measure4[i].measure);
      row.add(measure1[i].date.toString());
      rows.add(row);
    }

    String dir = (await getExternalStorageDirectory()).absolute.path + "/";
    filePath = "$dir";
    String fullPath = filePath + "$measurmentTitle.csv";
    File f = new File(fullPath);

    String csv = const ListToCsvConverter().convert(rows);
    file = await f.writeAsString(csv);
    print("Czas wykonania ${DateTime.now().difference(start).inMilliseconds}");

    if (file != null) await shareFile(fullPath);
  }

  shareFile(String filePath) async {
    await Share.shareFiles([filePath], text: 'Wykonany pomiar');
  }
}
