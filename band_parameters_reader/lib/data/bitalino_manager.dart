import 'package:band_parameters_reader/models/heart_beat_measure.dart';
import 'package:band_parameters_reader/models/measure.dart';
import 'package:band_parameters_reader/repositories/bitalino_cubit.dart';
import 'package:bitalino/bitalino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BitalinoManager {
  BITalinoController bitalinoController;
  final BuildContext context;
  List<HeartBeatMeasure> measures = [];

  BitalinoManager({this.context});

  void initialize() async {
    bitalinoController = BITalinoController(
      "20:16:12:21:39:01",
      CommunicationType.BTH,
    );

    try {
      await bitalinoController.initialize();
    } on PlatformException catch (Exception) {
      print("Initialization failed: ${Exception.message}");
    }

    connectToDevice();
  }

  Future<void> connectToDevice() async {
    try {
      await bitalinoController.connect(
        onConnectionLost: () {
          print("Connection lost");
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> startAcquisition() async {
    try {
      bool started = await bitalinoController.start([
        0,
      ], Frequency.HZ100, numberOfSamples: 10, onDataAvailable: (frame) {
        Measure measure = Measure(date: DateTime.now(), measure: frame.analog[0].round());
        context
            .bloc<BitalinoCubit>()
            .addMeasure(Measure(date: DateTime.now(), measure: frame.analog[0].round()));
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> endConnection() async {
    await bitalinoController.disconnect();
    await bitalinoController.dispose();
  }
}
