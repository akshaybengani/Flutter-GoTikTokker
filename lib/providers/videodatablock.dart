import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:GoTikTokker/models/videomodal.dart';
import 'package:flutter/material.dart';

class VideoDataBlock extends ChangeNotifier {
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;
  List<VideoModal> videosList = [];

  Future<void> uploadToServer(File videoFile) async {
    FirebaseUser user = await auth.currentUser();
    String uid = user.uid;
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("gotiktokker").child(DateTime.now().millisecondsSinceEpoch.toString());
    StorageUploadTask uploadTask = storageReference.putFile(videoFile);
    await uploadTask.onComplete;
    print("File Uploaded");
    await storageReference.getDownloadURL().then((value) async {
      databaseReference.child("GoTikTokker").child("videos").push().set({
        "likes": 0,
        "uid": uid,
        "vurl": value,
      });
    });
  }

  Future<void> fetchAllVideoMetaData() async {
    // Fetch all urls from server in VideoModal
    databaseReference
        .child("GoTikTokker")
        .child("videos")
        .once()
        .then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;

      for (var onekey in keys) {
        VideoModal model = VideoModal(
          likes: data[onekey]['likes'],
          uid: data[onekey]['uid'],
          vurl: data[onekey]['vurl'],
        );
        print("User uid is ${model.uid} ====  videoUrl is ${model.vurl} ");
        videosList.add(model);
        print("Length of list is ${videosList.length} ");
      }
    });

    // Set videomodallistitems
  }

  VideoModal getRandomShuffledVideo() {
    var len = videosList.length;
    var ranIndex = Random().nextInt(len);
    return videosList[1];
  }
}
