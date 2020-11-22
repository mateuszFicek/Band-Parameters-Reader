import 'package:band_parameters_reader/data/bitalino_manager.dart';
import 'package:band_parameters_reader/repositories/bitalino_cubit.dart';
import 'package:band_parameters_reader/widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BitalinoScreen extends StatefulWidget {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            FlatButton(onPressed: () => manager.initialize(), child: Text("Initialize")),
            FlatButton(onPressed: () => manager.connectToDevice(), child: Text("Connect")),
            FlatButton(onPressed: () => manager.startAcquisition(), child: Text("Start")),
            FlatButton(onPressed: () => manager.endConnection(), child: Text("Disconnect")),
            FlatButton(
                onPressed: () {
                  setState(() {});
                },
                child: Text("Refresh")),
            Flexible(
              child: BlocBuilder<BitalinoCubit, BitalinoState>(
                builder: (context, state) => Chart(data: state.measure),
              ),
            )
          ],
        ),
      ),
    );
  }
}
