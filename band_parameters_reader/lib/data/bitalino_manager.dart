import 'package:bitalino/bitalino.dart';
import 'package:flutter/services.dart';

class BitalinoManager {
  BITalinoController bitalinoController;

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
      bool success = await bitalinoController.start(
        [0],
        Frequency.HZ10,
        onDataAvailable: (BITalinoFrame frame) {
          print("Seguence: ${frame.sequence}"); // [int]
          print("Analog: ${frame.analog}"); // [List<int>]
          print("Digital: ${frame.digital}"); // [List<int>]
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> endConnection() async {
    await bitalinoController.disconnect();
    await bitalinoController.dispose();
  }
}
