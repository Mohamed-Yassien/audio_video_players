import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  AudioPlayer audioPlayer = AudioPlayer();

  bool isPlaying = false;
  IconData iconData = Icons.play_arrow_sharp;

  var duration = Duration.zero;
  var position = Duration.zero;

  @override
  void initState() {
    super.initState();
    audioPlayer.onDurationChanged.listen((val) {
      setState(() {
        duration = val;
      });
    });
    audioPlayer.onPositionChanged.listen((val) {
      setState(() {
        position = val;
      });
    });
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        iconData = Icons.play_arrow_sharp;
        isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Slider(
                value: position.inSeconds.toDouble(),
                min: 0,
                max: duration.inSeconds.toDouble(),
                onChanged: (val) async {
                  setState(() {
                    position = Duration(seconds: val.toInt());
                  });
                  await audioPlayer.seek(Duration(seconds: val.toInt()));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    position.toString().split('.').first,
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    duration.toString().split('.').first,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
              IconButton(
                onPressed: () async {
                  String assetUrl = 'audios/omry.mp3';
                  if (!isPlaying) {
                    await audioPlayer.play(
                      AssetSource(assetUrl),
                    );
                    setState(() {
                      iconData = Icons.pause;
                      isPlaying = true;
                      print(isPlaying);
                    });
                  } else {
                    await audioPlayer.pause();
                    setState(() {
                      iconData = Icons.play_arrow_sharp;
                      isPlaying = false;
                      print(isPlaying);
                    });
                  }
                },
                icon: Icon(
                  iconData,
                  size: 60,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
