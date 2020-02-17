import 'dart:io';
import 'dart:math';

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
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child("gotiktokker")
        .child(DateTime.now().millisecondsSinceEpoch.toString());
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
    await databaseReference
        .child("GoTikTokker")
        .child("videos")
        .once()
        .then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;

      for (var onekey in keys) {
        VideoModal model = VideoModal(
          id: onekey,
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
    try {
      var ranIndex = Random().nextInt(len);
      return videosList[ranIndex];
    } catch (err) {
      return videosList[0];
    }
  }

  Future<void> likeVideoByThisUser(VideoModal model) async {
    int newLikeCount = model.likes + 1;
    // final vidIndex = videosList.indexWhere((element) => element.id == model.id);
    try {
      await databaseReference
          .child("GoTikTokker")
          .child("videos")
          .child(model.id)
          .update({
        'likes': newLikeCount,
      });
      FirebaseUser user = await auth.currentUser();
      String uid = user.uid;
      await databaseReference
          .child("GoTikTokker")
          .child("Users")
          .child(uid)
          .child("Likes")
          .child(model.id)
          .set({"like": true, "vid": model.id});
      // videosList[vidIndex].likes = newLikeCount;
      // notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<bool> checkLikeStatus(VideoModal model) async {
    FirebaseUser user = await auth.currentUser();
    String uid = user.uid;
    bool likeCheck = false;
    try {
      await databaseReference
          .child("GoTikTokker")
          .child("Users")
          .child(uid)
          .child("Likes")
          .child(model.id)
          .once()
          .then((DataSnapshot snap) {
        likeCheck = snap.value['like'];
        print("Like Status is ${snap.value['like']}");
      });
      return likeCheck;
    } catch (err) {
      return likeCheck;
    }
  }

  Future<void> unLikeVideoByThisUser(VideoModal model) async {
    int newLikeCount = model.likes - 1;
    // final vidIndex = videosList.indexWhere((element) => element.id == model.id);
    try {
      await databaseReference
          .child("GoTikTokker")
          .child("videos")
          .child(model.id)
          .update({
        'likes': newLikeCount,
      });
      FirebaseUser user = await auth.currentUser();
      String uid = user.uid;
      await databaseReference
          .child("GoTikTokker")
          .child("Users")
          .child(uid)
          .child("Likes")
          .child(model.id)
          .set({"like": false, "vid": model.id});
      // videosList[vidIndex].likes = newLikeCount;
      // notifyListeners();
    } catch (err) {
      print(err);
    }
  }
}
