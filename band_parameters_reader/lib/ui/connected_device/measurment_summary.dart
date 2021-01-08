import 'dart:io';

import 'package:band_parameters_reader/models/measure.dart';
import 'package:band_parameters_reader/repositories/bitalino/bitalino_cubit.dart';
import 'package:band_parameters_reader/repositories/measurment/measurment_cubit.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/widgets/chart.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class MeasurmentSummary extends StatefulWidget {
  @override
  _MeasurmentSummaryState createState() => _MeasurmentSummaryState();
}

class _MeasurmentSummaryState extends State<MeasurmentSummary> {
  String measurmentTitle;
  TextEditingController _textEditingController = TextEditingController();
  File file;
  SfRangeValues _values;

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

  void initRange() async {
    await Future.delayed(
        Duration.zero,
        () => _values = SfRangeValues(
            0.0, context.bloc<MeasurmentCubit>().state.heartbeatMeasure.length.toDouble()));
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
                SizedBox(height: 160),
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
    return BlocBuilder<MeasurmentCubit, MeasurmentState>(builder: (_, state) {
      return Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: SfRangeSlider(
            activeColor: Color(0xFFDCD8FD),
            min: 0.0,
            max: state.heartbeatMeasure.length.toDouble(),
            values: _values,
            interval: (state.heartbeatMeasure.length / 8).roundToDouble(),
            stepSize: 1,
            showTicks: true,
            showLabels: true,
            enableTooltip: true,
            minorTicksPerInterval: 1,
            onChanged: (SfRangeValues values) {
              setState(() {
                _values = values;
              });
            },
          ));
    });
  }

  Widget _chartBuilder() {
    List<Measure> measures;
    return BlocBuilder<MeasurmentCubit, MeasurmentState>(builder: (_, state) {
      if (_values == null)
        _values = SfRangeValues(
            0.0, context.bloc<MeasurmentCubit>().state.heartbeatMeasure.length.toDouble());
      measures = List<Measure>.from(state.heartbeatMeasure)
          .getRange((_values.start as double).round(), (_values.end as double).round())
          .toList();

      return Container(
          height: 450,
          width: double.infinity,
          child: Chart(
            data: measures,
            canZoom: true,
          ));
    });
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
    String filePath;
    List<Measure> associateList = context.bloc<MeasurmentCubit>().state.heartbeatMeasure;

    List<List<dynamic>> rows = List<List<dynamic>>();
    List<dynamic> row = List();
    row.add("Id");
    row.add("Pomiar");
    row.add("Data");
    rows.add(row);
    for (int i = 0; i < associateList.length; i++) {
      List<dynamic> row = List();
      row.add(associateList[i].id);
      row.add(associateList[i].measure);
      row.add(associateList[i].date.toString());
      print(associateList[i].date);
      rows.add(row);
    }

    String dir = (await getExternalStorageDirectory()).absolute.path + "/";
    filePath = "$dir";
    print(" FILE " + filePath);
    String fullPath = filePath + "$measurmentTitle.csv";
    File f = new File(fullPath);

    String csv = const ListToCsvConverter().convert(rows);
    file = await f.writeAsString(csv);
    if (file != null) await shareFile(fullPath);
  }

  shareFile(String filePath) async {
    await Share.shareFiles([filePath], text: 'Wykonany pomiar');
  }
}
