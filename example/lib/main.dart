import 'package:battery_indicator/battery_indicator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BatteryIndicator _batteryIndicator;
  String _batteryCharge = 'unknown';

  @override
  void initState() {
    super.initState();

    _batteryIndicator = BatteryIndicator((value) {
      setState(() {
        _batteryCharge = '$value %';
        debugPrint('current charge: $_batteryCharge');
      });
    });
  }

  void _didBatteryChargeChange(Future<int> value) async {
    final batteryCharge = await value;
    setState(() {
      _batteryCharge = '$batteryCharge %';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text('Get Battery charge'),
                onPressed: () => _didBatteryChargeChange(
                  _batteryIndicator.getBatteryCharge(),
                ),
              ),
              Text('Battery charge: $_batteryCharge'),
            ],
          ),
        ),
      ),
    );
  }
}
