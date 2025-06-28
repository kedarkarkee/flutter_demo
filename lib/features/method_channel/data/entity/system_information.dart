import 'package:equatable/equatable.dart';

class SystemInformation extends Equatable {
  final int batteryLevel;
  final String deviceModel;
  final bool isCharging;
  final DateTime systemTime;

  const SystemInformation({
    required this.batteryLevel,
    required this.deviceModel,
    required this.isCharging,
    required this.systemTime,
  });

  factory SystemInformation.fromJson(Map<Object?, Object?> json) {
    return SystemInformation(
      batteryLevel: json['batteryLevel'] as int,
      deviceModel: json['deviceModel'] as String,
      isCharging: json['isCharging'] as bool,
      systemTime: DateTime.parse(json['systemTime'] as String),
    );
  }

  SystemInformation copyWith({
    int? batteryLevel,
    String? deviceModel,
    bool? isCharging,
    DateTime? systemTime,
  }) {
    return SystemInformation(
      batteryLevel: batteryLevel ?? this.batteryLevel,
      deviceModel: deviceModel ?? this.deviceModel,
      isCharging: isCharging ?? this.isCharging,
      systemTime: systemTime ?? this.systemTime,
    );
  }

  @override
  List<Object?> get props => [
    batteryLevel,
    deviceModel,
    isCharging,
    systemTime,
  ];
}
