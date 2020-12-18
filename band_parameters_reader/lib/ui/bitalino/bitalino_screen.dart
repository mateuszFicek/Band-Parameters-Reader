import 'package:band_parameters_reader/data/bitalino_manager.dart';
import 'package:band_parameters_reader/models/measure.dart';
import 'package:band_parameters_reader/repositories/bitalino_cubit.dart';
import 'package:band_parameters_reader/ui/bitalino/bitalino_measurment.dart';
import 'package:band_parameters_reader/utils/colors.dart';
import 'package:band_parameters_reader/widgets/chart.dart';
import 'package:bitalino/bitalino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BitalinoScreen extends StatefulWidget {
  final String address;

  const BitalinoScreen({Key key, this.address}) : super(key: key);
  @override
  _BitalinoScreenState createState() => _BitalinoScreenState();
}

class _BitalinoScreenState extends State<BitalinoScreen> {
  BitalinoManager manager;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      manager = BitalinoManager(context: context);
      manager.initialize(widget.address);
      Future.delayed(
          Duration(milliseconds: 300), () => manager.connectToDevice());
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
          "Bitalino",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
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
          }),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BitalinoMeasurment(manager: manager)));
              },
              child: Text("Measurment screen")),
          _chartBuilder(),
        ],
      ),
    );
  }

  Widget _chartBuilder() {
    return BlocBuilder<BitalinoCubit, BitalinoState>(builder: (context, state) {
      return Container(
        height: 500,
        width: double.infinity,
        child: Chart(
          canZoom: true,
          data: state.measure,
        ),
      );
    });
  }
}
