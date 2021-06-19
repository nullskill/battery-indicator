import 'package:flutter/services.dart';

class BatteryIndicator {
  BatteryIndicator(this.batteryChargeListener) {
    _initBatteryIndicator();
  }

  static const MethodChannel _channel = const MethodChannel('battery_indicator/channel');
  static const _getBatteryChargeMethod = 'getBatteryCharge';
  static const _didBatteryChargeChangeMethod = 'didBatteryChargeChange';

  /// A callback to be called when _didBatteryChargeChangeMethod is fired
  final void Function(int charge) batteryChargeListener;

  void _initBatteryIndicator() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case _didBatteryChargeChangeMethod:
          batteryChargeListener(call.arguments);
          break;
        default:
          throw UnimplementedError();
      }
    });
  }

  /// Invokes platform method to get battery remaining energy info
  Future<int> getBatteryCharge() async {
    return await _channel.invokeMethod(_getBatteryChargeMethod);
  }
}
