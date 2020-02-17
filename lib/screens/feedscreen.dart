import 'dart:async';
import 'package:GoTikTokker/models/videomodal.dart';
import 'package:GoTikTokker/providers/videodatablock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPrevVideosAndPlayOne();
  }

  void fetchPrevVideosAndPlayOne() async {
    await Provider.of<VideoDataBlock>(context, listen: false)
        .fetchAllVideoMetaData()
        .then((value) => nextVideoToPlay());
  }

  void nextVideoToPlay() async {
    // setState(() {
    //   isLoading = true;
    // });
    VideoModal model = Provider.of<VideoDataBlock>(context, listen: false)
        .getRandomShuffledVideo();
    _controller = VideoPlayerController.network(model.vurl);
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    _controller.play();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.pink,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                    child: GestureDetector(
                  onTap: () {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  },
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                )),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.pink,
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }
}
