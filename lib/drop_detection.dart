import 'package:flutter/material.dart';
import 'package:sensors/backend/deceleration_class.dart';
import 'package:sensors/backend/sound.dart';

class DropDetection extends StatefulWidget {
  const DropDetection({super.key});

  @override
  State<DropDetection> createState() => _DropDetectionState();
}

class _DropDetectionState extends State<DropDetection>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool accident = false;
  bool emergencyRequestSent = false;

  @override
  void initState() {
    // Animation controller used as timer for CircularProgressIndicator
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..addListener(() {
            setState(() {});
          });

    controller.addStatusListener((status) {
      // If timer completed, meaning - accident detected and user did not click "I'm OK" button
      if (status == AnimationStatus.completed) {
        sendEmergency();
      }

      // Timer starts when accident detected, then play the beeper
      if (status == AnimationStatus.forward) {
        _playBeeper();
      }
    });

    controller.addListener(
      () {
        // If "I'm Ok" button is clicked reset the timer and stop the beeper
        if (!accident && controller.isAnimating) {
          controller.reset();
          _stopBeeper();
        }
      },
    );

    // Listen to sudden deceleration event
    // **** Optional Config ****
    // (optional) Pass the threshold property in the isSuddenDecelerating() funtion to set the max acceleration or deceleration above which accident is detected
    Acceleration().isSuddenDecelerating().listen((event) {
      if (event == true) {
        // Sudden deceleration suggests accident occured
        setState(() {
          accident = true;
        });
        // Timer starts
        controller.forward();
        // _reset();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _playBeeper() async {
    final BeeperSound beeper = await BeeperSound.create();
    beeper.play();
  }

  void _stopBeeper() async {
    final BeeperSound beeper = await BeeperSound.create();
    beeper.stop();
  }

// Function to send the emergency signal
// Currently fake
  void sendEmergency() {
    print('\n\n**********\nEmergency sent\\n**********\n\n');
    setState(() {
      emergencyRequestSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: accident ? Colors.red.shade700 : null,
        appBar: AppBar(
          backgroundColor: accident ? Colors.red : null,
          title: const Text('Drop Detection App'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Alarm will sound on sudden deceleration'),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Text(
                accident ? 'Accident Detected' : 'Safe Till now',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: accident ? Colors.white : Colors.green,
                    fontSize: 50),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            if (emergencyRequestSent)
              const Text(
                "Emergency Request has been sent to the hospital and family",
                textAlign: TextAlign.center,
              ),
            if (controller.isAnimating)
              Stack(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: CircularProgressIndicator(
                      semanticsLabel: 'Progress',
                      value: controller.value,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        accident = false;
                      });
                    },
                    child: ClipOval(
                      child: Container(
                        height: 200,
                        width: 200,
                        color: Colors.green.shade700,
                        child: const Center(
                          child: Text(
                            "I'm OK",
                            style: TextStyle(color: Colors.white, fontSize: 40),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const Spacer(),
            if (emergencyRequestSent)
              ElevatedButton(
                onPressed: () {
                  controller.reset();
                  _stopBeeper();
                  setState(() {
                    accident = false;
                    emergencyRequestSent = false;
                  });
                },
                child: const Text('Reset'),
              ),
          ],
        ));
  }
}
