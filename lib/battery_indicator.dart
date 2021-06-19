import 'package:flutter/services.dart';

class BatteryIndicator {
  BatteryIndicator(this.batteryChargeListener) {
    _initBatteryIndicator();
  }

  static const MethodChannel _channel =
      const MethodChannel('battery_indicator/channel');
  static const _getBatteryChargeMethod = 'getBatteryCharge';
  static const _didBatteryChargeChangeMethod = 'didBatteryChargeChange';

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

  Future<int> getBatteryCharge() async {
    return await _channel.invokeMethod(_getBatteryChargeMethod);
  }
}
