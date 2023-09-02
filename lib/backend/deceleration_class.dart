import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart' as sensors;

class Acceleration {
  Stream<bool> isSuddenDecelerating({double threshold = 70}) {
    StreamController<bool> controller = StreamController();

    // Listen to accelerometer events and if the positive value of acceleration in any axis is more than threshold yield true
    sensors.accelerometerEvents.listen((event) {
      // print(event);
      if (event.x.abs() > threshold ||
          event.y.abs() > threshold ||
          event.z.abs() > threshold) {
        controller.add(true);
      }
    });

    return controller.stream;
  }
}
