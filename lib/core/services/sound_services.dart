import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class SoundServices {
  // ignore: deprecated_member_use
  Soundpool pool = Soundpool(streamType: StreamType.notification);

  Future<void> loadSound() async {
    int soundId = await rootBundle
        .load("assets/audio/payment success.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
    log('Sound played with stream id $streamId');
  }

  Future<void> recievedSound() async {
    int soundId = await rootBundle
        .load("assests/sounds/message_sended.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
    log('Sound played with stream id $streamId');
  }
}
