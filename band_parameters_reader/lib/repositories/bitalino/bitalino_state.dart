part of 'bitalino_cubit.dart';

@immutable
class BitalinoState {
  final List<List<Measure>> measure;

  final bool isCollectingData;

  BitalinoState({this.measure, this.isCollectingData});

  BitalinoState copyWith(
      {BluetoothDevice device, List<List<Measure>> measures, bool isCollecting}) {
    return BitalinoState(
        measure: measures ?? this.measure, isCollectingData: isCollecting ?? this.isCollectingData);
  }
}

class BitalinoInitial extends BitalinoState {
  BitalinoInitial() : super(measure: [[], [], [], []], isCollectingData: false);
}
