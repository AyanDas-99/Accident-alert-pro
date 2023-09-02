import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class BeeperSound {
  // Singleton instantiation
  static final BeeperSound _instance = BeeperSound.internal();
  static Soundpool pool = Soundpool.fromOptions(
      options: const SoundpoolOptions(streamType: StreamType.ring));
  static late int soundId;
  static late int streamId;
  BeeperSound.internal();

  static Future<BeeperSound> create() async {
    soundId = await rootBundle
        .load('assets/beeper.mp3')
        .then((ByteData soundData) => pool.load(soundData));

    return _instance;
  }

  Future<void> play() async {
    streamId = await pool.play(
      soundId,
      repeat: 10,
    );
  }

  Future<void> stop() async {
    await pool.stop(streamId);
  }
}
