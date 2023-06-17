import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';  // needed for Timer

enum PlayerState { PLAYING, PAUSED }

class AudioPlayerUI extends StatefulWidget {
  final String url;
  final ValueNotifier<bool> playNotifier;  // New Notifier

  AudioPlayerUI({required this.url, required this.playNotifier});

  @override
  _AudioPlayerUIState createState() => _AudioPlayerUIState();
}

class _AudioPlayerUIState extends State<AudioPlayerUI> {
  late AudioPlayer _audioPlayer;
  late Timer _positionTimer;
  PlayerState _playerState = PlayerState.PAUSED;
  double _currentPosition = 0;
  double _totalDuration = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _totalDuration = d.inMilliseconds.toDouble();
      });
    });

    _positionTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) async {
      int result = (await _audioPlayer.getCurrentPosition())!.inMilliseconds;
      setState(() {
        _currentPosition = result.toDouble();
      });
    });

    // Listen to the ValueNotifier
    widget.playNotifier.addListener(_playPauseAudio);
  }

  // Function to play or pause audio
  void _playPauseAudio() async {
    if (widget.playNotifier.value) {
      await _audioPlayer.play(UrlSource(widget.url));
      setState(() {
        _playerState = PlayerState.PLAYING;
      });
    } else {
      await _audioPlayer.pause();
      setState(() {
        _playerState = PlayerState.PAUSED;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _positionTimer.cancel();
    widget.playNotifier.removeListener(_playPauseAudio);  // Remove the listener
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
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
              value: (_totalDuration > 0) ? _currentPosition / _totalDuration : 0.0,
            ),
          ),
        ),
      ],
    );
  }
}