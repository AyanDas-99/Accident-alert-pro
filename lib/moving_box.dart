import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensors;

class MovingBox extends StatefulWidget {
  const MovingBox({super.key});

  @override
  State<MovingBox> createState() => _MovingBoxState();
}

class _MovingBoxState extends State<MovingBox> {
  // late AnimationController _controller;
  double xOffset = 0.0;

  @override
  void initState() {
    super.initState();

    sensors.accelerometerEvents.listen((sensors.AccelerometerEvent event) {
      // Update the x-offset based on accelerometer data
      setState(() {
        xOffset = (double.parse((-event.x).toStringAsFixed(2)) * 0.1)
            .clamp(-0.35, 0.35); // Adjust the sensitivity as needed
      });
    });

    // _controller.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 200,
          ),
          AnimatedSlide(
            duration: const Duration(milliseconds: 600),
            offset: Offset(xOffset, 0),
            child: Center(
              child: Container(
                height: 100,
                width: 100,
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }
}
