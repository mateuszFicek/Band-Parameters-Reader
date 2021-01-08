import 'package:band_parameters_reader/ui/connected_device/connected_device.dart';
import 'package:band_parameters_reader/ui/main/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'Band Parameters Reader',
      routes: {
        '/': (context) => BandParametersReaderHomePage(),
        '/connectedDevice': (context) => new ConnectedDevicePage(),
      },
      initialRoute: '/',
    );
  }
}
