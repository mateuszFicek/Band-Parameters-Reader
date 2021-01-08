import 'package:band_parameters_reader/models/measure.dart';
import 'package:band_parameters_reader/repositories/bitalino/bitalino_cubit.dart';
import 'package:bitalino/bitalino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BitalinoManager {
  BITalinoController bitalinoController;
  final BuildContext context;
  List<Measure> measures = [];

  BitalinoManager({this.context});

  void initialize(String address) async {
    bitalinoController = BITalinoController(
      address,
      CommunicationType.BTH,
    );

    try {
      await bitalinoController.initialize();
    } on PlatformException catch (Exception) {
      print("Initialization failed: ${Exception.message}");
    }
  }

  Future<BITalinoState> getState() async {
    final state = await bitalinoController.state();
    return state;
  }

  bool connected() {
    return bitalinoController.connected;
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
      await bitalinoController.start([0, 1, 2, 3], Frequency.HZ1000, numberOfSamples: 10,
          onDataAvailable: (frame) {
        for (int i = 0; i < 4; i++) {
          Measure measure = Measure(
              date: DateTime.now(),
              measure: frame.analog[i].round(),
              id: context.bloc<BitalinoCubit>().state.measure[0].length);

          context.bloc<BitalinoCubit>().addMeasure(measure, i);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> stopAcquisition() async {
    try {
      await bitalinoController.stop();
    } catch (e) {
      print(e);
    }
  }

  Future<void> endConnection() async {
    await bitalinoController.disconnect();
    await bitalinoController.dispose();
  }
}
