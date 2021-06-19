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
  static const batteryChargeTitle = 'Battery charge: ';
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
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

  Future<void> didBatteryChargeChange(Future<int> value) async {
    final batteryCharge = await value;
    setState(() {
      _batteryCharge = '$batteryCharge %';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text('Get Battery charge'),
                  onPressed: () async {
                    await didBatteryChargeChange(_batteryIndicator.getBatteryCharge());
                    final snackBar = SnackBar(
                      content: Text('$batteryChargeTitle$_batteryCharge'),
                      action: SnackBarAction(
                        label: 'Ok',
                        onPressed: () {
                          print('$batteryChargeTitle$_batteryCharge');
                        },
                      ),
                    );
                    scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
                  },
                ),
                Text('$batteryChargeTitle$_batteryCharge'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
