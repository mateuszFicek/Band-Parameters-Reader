part of 'bitalino_cubit.dart';

@immutable
class BitalinoState {
  final List<Measure> measure;

  BitalinoState({this.measure});

  BitalinoState copyWith({BluetoothDevice device, List<Measure> measures}) {
    return BitalinoState(measure: measures ?? this.measure);
  }
}

class BitalinoInitial extends BitalinoState {
  BitalinoInitial() : super(measure: []);
}
