import 'dart:async';
import 'package:GoTikTokker/models/videomodal.dart';
import 'package:GoTikTokker/providers/videodatablock.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool isLiked = false;
  VideoModal model;

  @override
  void initState() {
    super.initState();
    fetchPrevVideosAndPlayOne();
    print("I passed throught init state data collection");
  }

  void fetchPrevVideosAndPlayOne() async {
    await Provider.of<VideoDataBlock>(context, listen: false)
        .fetchAllVideoMetaData();
    await nextVideoToPlay();
  }

  Future<void> nextVideoToPlay() async {
    model = Provider.of<VideoDataBlock>(context, listen: false)
        .getRandomShuffledVideo();
    print("I am here");
    _controller = VideoPlayerController.network(model.vurl);
    print("I reach here");
    _initializeVideoPlayerFuture = _controller.initialize();
    print("I also Reached");

    isLiked = await Provider.of<VideoDataBlock>(context, listen: false)
        .checkLikeStatus(model);

    setState(() {
      isLoading = false;
    });
    _controller.play();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void likeVideoByThisUser() async {
    if (isLiked) {
      await Provider.of<VideoDataBlock>(context, listen: false)
          .unLikeVideoByThisUser(model);
      setState(() {
        isLiked = !isLiked;
        model.likes = model.likes - 1;
      });
    } else {
      await Provider.of<VideoDataBlock>(context, listen: false)
          .likeVideoByThisUser(model);
      setState(() {
        isLiked = !isLiked;
        model.likes = model.likes + 1;
      });
    }
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(30),
                      child: GestureDetector(
                        onTap: likeVideoByThisUser,
                        child: isLiked
                            ? CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.pink,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.thumbsUp,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    Text(model.likes.toString()),
                                  ],
                                ),
                              )
                            : CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      FontAwesomeIcons.thumbsUp,
                                      size: 30,
                                      color: Colors.pink,
                                    ),
                                    Text(model.likes.toString()),
                                  ],
                                ),
                              ),
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }
}
