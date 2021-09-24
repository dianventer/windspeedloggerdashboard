class LoggerData {
  int timestamp;
  double batteryVoltage;
  double windSpeed;

  LoggerData({
    this.timestamp,
    this.batteryVoltage,
    this.windSpeed,
  });

  factory LoggerData.fromSheets(Map<String, dynamic> loggerData) {
    print(loggerData);
    if (loggerData != null) {
      return LoggerData(
        timestamp: loggerData['Timestamp'] as int,
        batteryVoltage: loggerData['BatteryVoltage'] as double,
        windSpeed: 1 / ((1 / (loggerData['WindSpeed'] as double)) * 2.2 * ((2 * 3.14) * 0.05)),
      );
    } else {
      return LoggerData();
    }
  }
}

//DateTime.fromMillisecondsSinceEpoch(loggerData['Timestamp'] * 1000),
