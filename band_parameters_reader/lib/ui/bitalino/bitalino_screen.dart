import 'package:band_parameters_reader/data/bitalino_manager.dart';
import 'package:flutter/material.dart';

class BitalinoScreen extends StatefulWidget {
  @override
  _BitalinoScreenState createState() => _BitalinoScreenState();
}

class _BitalinoScreenState extends State<BitalinoScreen> {
  BitalinoManager manager;
  @override
  void initState() {
    manager = BitalinoManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          FlatButton(
              onPressed: () => manager.initialize(), child: Text("Initialize")),
          FlatButton(
              onPressed: () => manager.connectToDevice(),
              child: Text("Connect")),
          FlatButton(
              onPressed: () => manager.startAcquisition(),
              child: Text("Start")),
          FlatButton(
              onPressed: () => manager.endConnection(),
              child: Text("Disconnect")),
        ],
      ),
    );
  }
}
