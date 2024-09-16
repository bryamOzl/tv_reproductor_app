import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String? url;

  const VideoPlayerScreen({super.key, required this.url});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreen();
}

class _VideoPlayerScreen extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url ?? ""));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: VideoPlayer(_controller),
            ),
            _ControlsOverlay(controller: _controller),
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        color: Colors.black26,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: () async {
                  final position = await controller.position;
                  controller.seekTo(Duration(seconds: position!.inSeconds - 5));
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 20),
              controller.value.isPlaying
                  ? MaterialButton(
                      onPressed: () {
                        controller.pause();
                      },
                      child: const Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    )
                  : MaterialButton(
                      onPressed: () {
                        controller.play();
                      },
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
              const SizedBox(width: 20),
              MaterialButton(
                onPressed: () async {
                  final position = await controller.position;
                  controller.seekTo(Duration(seconds: position!.inSeconds + 5));
                },
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 20),
              PopupMenuButton<double>(
                initialValue: controller.value.playbackSpeed,
                tooltip: 'Playback speed',
                color: Colors.white,
                onSelected: (speed) {
                  controller.setPlaybackSpeed(speed);
                },
                itemBuilder: (context) {
                  return [
                    for (final speed in _examplePlaybackRates)
                      PopupMenuItem(
                        value: speed,
                        child: Text('${speed}x'),
                      )
                  ];
                },
                child: Text(
                  '${controller.value.playbackSpeed}x',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
