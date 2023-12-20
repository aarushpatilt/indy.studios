import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';  // needed for Timer

enum PlayerState { PLAYING, PAUSED }

class AudioPlayerUI extends StatefulWidget {
  final String url;
  final ValueNotifier<bool> playNotifier;
  final Color barColor;

  AudioPlayerUI({
    required this.url,
    required this.playNotifier,
    required this.barColor,
  });

  @override
  _AudioPlayerUIState createState() => _AudioPlayerUIState();
}

class _AudioPlayerUIState extends State<AudioPlayerUI> {
  PlayerState _playerState = PlayerState.PAUSED;
  double _currentPosition = 0;
  double _totalDuration = 0;

  @override
  void initState() {
    super.initState();

    AudioManager().audioPlayer.onDurationChanged.listen((Duration d) {
      if (mounted) {
        setState(() {
          _totalDuration = d.inMilliseconds.toDouble();
        });
      }
    });

    AudioManager().audioPlayer.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() {
          _currentPosition = p.inMilliseconds.toDouble();
        });
      }
    });

    widget.playNotifier.addListener(_playPauseAudio);
  }

  void _playPauseAudio() {
    AudioManager audioManager = AudioManager();
    if (widget.playNotifier.value) {
      audioManager.play(widget.url);
      if (mounted) {
        setState(() {
          _playerState = PlayerState.PLAYING;
        });
      }
    } else {
      audioManager.pause();
      if (mounted) {
        setState(() {
          _playerState = PlayerState.PAUSED;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.playNotifier.removeListener(_playPauseAudio);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 2.0,
            child: LinearProgressIndicator(
              minHeight: 2.0,
              backgroundColor: Color.fromARGB(129, 158, 158, 158),
              valueColor: AlwaysStoppedAnimation<Color>(widget.barColor),
              value: (_totalDuration > 0) ? _currentPosition / _totalDuration : 0.0,
            ),
          ),
        ),
      ],
    );
  }
}

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final AudioPlayer audioPlayer = AudioPlayer();

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  void play(String url) async {
    await audioPlayer.play(UrlSource(url));
  }

  void pause() async {
    await audioPlayer.pause();
  }
}