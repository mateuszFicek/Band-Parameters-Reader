import 'dart:io';

import 'package:band_parameters_reader/models/measure.dart';
import 'package:band_parameters_reader/repositories/bitalino_cubit.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class BitalinoMeasurmentSummary extends StatefulWidget {
  @override
  _BitalinoMeasurmentSummaryState createState() =>
      _BitalinoMeasurmentSummaryState();
}

class _BitalinoMeasurmentSummaryState extends State<BitalinoMeasurmentSummary> {
  String measurmentTitle;
  TextEditingController _textEditingController = TextEditingController();
  File file;

  @override
  void initState() {
    super.initState();
    initTitle();
  }

  void initTitle() {
    String dateFormatted =
        DateFormat('yyyy_MM_dd_kk_mm').format(DateTime.now());
    measurmentTitle = "pomiar_$dateFormatted";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: UIColors.GRADIENT_DARK_COLOR,
        title: Text(
          measurmentTitle,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 80, left: 15, right: 15, top: 24),
            child: ListView(
              children: [
                _titleInput(),
                SizedBox(height: 16),
              ],
            ),
          ),
          _endButton(),
        ],
      ),
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

  Widget _endButton() {
    return Align(
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
                getCsv();
              },
              child: Text(
                'Wyjdź do ekranu głównego',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            )),
      ),
    );
  }

  getCsv() async {
    String filePath;
    List<Measure> associateList = context.bloc<BitalinoCubit>().state.measure;

    List<List<dynamic>> rows = List<List<dynamic>>();
    List<dynamic> row = List();
    row.add("Id");
    row.add("Measure");
    row.add("Date");
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
    File f = new File(filePath + "$measurmentTitle.csv");

    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
  }
}
