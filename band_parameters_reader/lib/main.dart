import 'package:band_parameters_reader/ui/main/main.dart';
import 'package:flutter/material.dart';

import 'di/provider_container.dart';

void main() {
  runApp(ProviderContainer(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'Band Parameters Reader',
      routes: {
        '/': (context) => BandParametersReaderHomePage(),
      },
      initialRoute: '/',
    );
  }
}
