import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class ProviderContainer extends StatefulWidget {
  final Widget child;

  ProviderContainer({Key key, @required this.child});

  @override
  State<StatefulWidget> createState() => ProviderContainerState();
}

class ProviderContainerState extends State<ProviderContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if blocs will be ready add here
    // return MultiBlocProvider(providers: [], child: widget.child);

    return widget.child;
  }
}
