import 'dart:io';

import 'package:GoTikTokker/providers/videodatablock.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class NewScreen extends StatefulWidget {
  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  String mypath;
  bool nowInitialize = false;
  bool videoTaken = false;
  //bool _imagePickerActive = false;
  VideoPlayerController _controller;
  bool completeFlag = false;
  Future<void> _initializeVideoPlayerFuture;
  String uploadMsg = "";
  File videoFile;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _takeVideo();
    });
  }

  void _takeVideo() async {
    
    videoFile = await ImagePicker.pickVideo(source: ImageSource.camera);
    if (videoFile == null) {
      videoTaken = true;
      return;
    }
    mypath = videoFile.path;
    _controller = VideoPlayerController.file(videoFile);
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      setState(() {
        nowInitialize = true;
      });
    });
    
  }

  Future<void> uploadToServer() async {
    setState(() {
      nowInitialize = false;
    });
    await Provider.of<VideoDataBlock>(context, listen: false)
        .uploadToServer(videoFile)
        .then((value) {
      setState(() {
        completeFlag = true;
        uploadMsg = "Uploaded Successfully";
      });
    }).catchError((err){
      uploadMsg = "Something went wrong please try again";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Video")),
      body: Container(
        margin: EdgeInsets.all(20),
        child: nowInitialize
            ? Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: _controller.value.initialized
                        ? GestureDetector(
                            onTap: () {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            },
                            child: AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      padding: EdgeInsets.all(10),
                      onPressed: uploadToServer,
                      color: Colors.pink,
                      child: Text(
                        'Upload',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: completeFlag
                    ? Text(uploadMsg)
                    : CircularProgressIndicator()),
      ),
    );
  }
}
