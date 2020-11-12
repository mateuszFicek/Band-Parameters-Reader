class BleGATTServices {
  static const String HEART_RATE_SERVICE = "180d";
  static const String BATTERY_SERVICE = "180f";
  static const String MI_BAND_SERVICE = "fee0";
  static const String ALERT_NOTIFICATION_SERVICE = "1811";
}

class BleGATTCharacteristics {
  static const String HEART_RATE_MEASURMENT = "2a37";
  static const String HEART_RATE_CONTROLL_POINT = "2a39";
  static const String NEW_ALERT = "2a46";
  static const String BATTERY_LEVEL = "2a19";
  static const String STEPS = "00000007";
  static const String SENSORS = '00000001';
  static const String SENSORS_DATA = '00000002';
}
