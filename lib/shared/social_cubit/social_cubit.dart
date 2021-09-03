import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/models/comment_model.dart';
import 'package:social/models/like_model.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/notification_model.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/recent_messages_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/modules/feeds_screen/feeds_screen.dart';
import 'package:social/modules/notifications_screen/notifications_screen.dart';
import 'package:social/modules/users_screen/users_screen.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/social_cubit/social_states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);

  int bottomNavBarCurrentIndex = 0;

  List<Widget> bottomNavBarScreens = [
    FeedsScreen(),
    NotificationScreen(),
    UsersScreen(),
  ];

  Widget chooseBotNavBarScreen(int index) {
    return bottomNavBarScreens[index];
  }

  void changeBottomNavBarCurrentIndex(int index) {
    bottomNavBarCurrentIndex = index;
    emit(ChangeBotNavBarState(bottomNavBarCurrentIndex));
  }

  /* get user data from fireStore */
  UserModel? model;

  void getUserData() {
    emit(UserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((event) {
      model = null;
      model = UserModel.fromJson(event.data());
      print(model!.profileImage);
      emit(UserSuccessState());
    });
  }

  /* get another user data from fireStore */
  UserModel? personModel;

  void getAnotherPersonData({required String? personUid}) {
    emit(UserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(personUid)
        .snapshots()
        .listen((event) {
      personModel = UserModel.fromJson(event.data());
      print(personModel!.name);
      print(personModel!.bio);
      emit(UserSuccessState());
    });
  }

  // upload image to Storage
  File? profileImage;
  File? coverImage;

  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProfileImagePickedSuccessState());
    } else {
      emit(ProfileImagePickedErrorState());
      print('no image selected');
    }
  }

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(CoverImagePickedSuccessState());
    } else {
      emit(CoverImagePickedErrorState());
      print('no image selected');
    }
  }

  String profileImageUrl = '';

  Future<void> uploadProfileImage() async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(ProfileImageUploadSuccessState());
        print(value);
        profileImageUrl = value;
        // update profile image
        updateProfileImage();
      }).catchError((error) {
        emit(ProfileImageUploadErrorState());
        print(error.toString());
      });
    }).catchError((error) {
      emit(ProfileImageUploadErrorState());
      print(error.toString());
    });
  }

  String coverImageUrl = '';

  Future<void> uploadCoverImage() async {
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(CoverImageUploadSuccessState());
        print(value);
        coverImageUrl = value;
        // update cover image
        updateCoverImage();
      }).catchError((error) {
        emit(CoverImageUploadErrorState());
        print(error.toString());
      });
    }).catchError((error) {
      emit(CoverImageUploadErrorState());
      print(error.toString());
    });
  }

  String newBio = '';

  Future<void> updateProfileImage() async {
    if (profileImageUrl != '') {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(model!.uid)
          .update({'profileImage': profileImageUrl}).then((value) {
        emit(ProfileImageUpdateSuccessState());
      }).catchError((error) {
        emit(ProfileImageUpdateErrorState());
      });
    }
  }

  Future<void> updateCoverImage() async {
    if (coverImageUrl != '') {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(model!.uid)
          .update({'coverImage': coverImageUrl}).then((value) {
        emit(CoverImageUpdateSuccessState());
      }).catchError((error) {
        emit(CoverImageUpdateErrorState());
      });
    }
  }

  Future<void> updateBio() async {
    if (newBio != '') {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(model!.uid)
          .update({'bio': newBio}).then((value) {
        emit(BioUpdateSuccessState());
      }).catchError((error) {
        emit(BioUpdateErrorState());
      });
    }
  }

  /* trying to handling uploading and updating ,
  i noticed that getUserData finished before updated */
  ////////////////////////////////////////////////////////
  // Future<void> uploadUserData()async
  // {
  //   if (profileImage != null) {
  //     await uploadProfileImage();
  //   }
  //   if (coverImage != null) {
  //     await uploadCoverImage();
  //   }
  // }
  //
  // Future <void> updateUserData()async
  // {
  //   await updateProfileImage();
  //   await updateCoverImage();
  //   await updateBio();
  // }
  //
  // void uploadAndUpdate()
  // {
  //   uploadUserData().then((value) {
  //     updateUserData().then((value) {
  //       getUserData();
  //     });
  //   });
  // }
  ////////////////////////////////////////////////////////

  // Post configurations
  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PostImagePickedSuccessState());
    } else {
      emit(PostImagePickedErrorState());
      print('no image selected');
    }
  }

  void uploadPostImage({
    required String body,
    required String datetime,
  }) {
    emit(PostImageUploadLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(PostImageUploadSuccessState());
        print(value);
        uploadPost(body: body, datetime: datetime, postImage: value);
      }).catchError((error) {
        emit(PostImageUploadErrorState());
        print(error.toString());
      });
    }).catchError((error) {
      emit(PostImageUploadErrorState());
      print(error.toString());
    });
  }

  void removeImageOfThePost() {
    postImage = null;
    emit(RemoveImageOfThePostState());
  }

  void uploadPost({
    required String body,
    required String datetime,
    String postImage = '',
  }) {
    PostModel postModel = PostModel(
      name: model!.name,
      uid: model!.uid,
      profileImage: model!.profileImage,
      body: body,
      datetime: datetime,
      postImage: postImage,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc()
        .set(postModel.toMap())
        .then((value) {
      emit(CreatePostSuccessState());
    }).catchError((error) {
      emit(CreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<bool> likedByMe = [];
  int counter = 0;

  List<int> commentsNumber = [];
  void getPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datetime')
        .snapshots()
        .listen((event) {
      posts = [];
      likes = [];
      postsId = [];
      likedByMe = [];
      counter = 0;
      commentsNumber = [];
      emit(GetPostSuccessState());
      event.docs.forEach((element) {
        element.reference.collection('likes').get().then((value) {
          emit(GetPostSuccessState());
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
          value.docs.forEach((element) {
            if (element.id == model!.uid) {
              counter++;
            }
          });
          if (counter > 0) {
            likedByMe.add(true);
          } else {
            likedByMe.add(false);
          }
          counter = 0;
        }).catchError((error) {
          emit(GetPostErrorState());
        });

        element.reference.collection('comments').get().then((value) {
          commentsNumber.add(value.docs.length);
        }).catchError((error) {});
      });
    });
  }

  // List<int> commentsNumber = [];

  // trying to get comments number
  // void getCommentsNumber()
  // {
  //   commentsNumber= [];
  //   postsId.forEach((element) {
  //     FirebaseFirestore.instance
  //         .collection('posts')
  //         .doc(element).collection('comments').get().then((value) {
  //           emit(GetCommentsNumbersSuccessState());
  //           commentsNumber.add(value.docs.length);
  //     }).catchError((error){
  //       emit(GetCommentsNumbersErrorState());
  //     });
  //   });
  //
  // }

  // trying to get the updated profile pic instead of the old one when the user post
  // String? getImageFromUid (String? uid)
  // {
  //   FirebaseFirestore.instance.collection('users').doc(uid).get().then((value){
  //     UserModel demoUserModel = UserModel.fromJson(value.data());
  //     emit(GetProfileImageFromUidSuccessState());
  //     return demoUserModel.profileImage;
  //
  //
  //   }).catchError((error){
  //     emit(GetProfileImageFromUidErrorState());
  //     print(error.toString());
  //   });
  // }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uid)
        .set({'like': true}).then((value) {
      emit(LikeSuccessState());
    }).catchError((error) {
      emit(LikeErrorState());
      print(error.toString());
    });
  }

  List<UserModel> users = [];

  void getAllUsers() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      users = [];
      emit(GetAllUsersSuccessState());
      event.docs.forEach((element) {
        if (element.data()['uid'] != model!.uid)
          users.add(UserModel.fromJson(element.data()));
      });
    });
  }

  List<UserModel> personUsers = [];

  void getAllPersonUsers({required String? personUid}) {
    FirebaseFirestore.instance.collection('users').snapshots().listen((event) {
      personUsers = [];
      emit(GetAllUsersSuccessState());
      event.docs.forEach((element) {
        if (element.data()['uid'] != personUid)
          personUsers.add(UserModel.fromJson(element.data()));
      });
    });
  }

  void sendMessage({
    required String? receiverId,
    required String? dateTime,
    required String? text,
  }) {
    MessageModel message = MessageModel(
        dateTime: dateTime,
        receiverId: receiverId,
        senderId: model!.uid,
        text: text);

    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(message.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
      print(error.toString());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(model!.uid)
        .collection('messages')
        .add(message.toMap())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
      print(error.toString());
    });
  }

  List<MessageModel> messages = [];
  void getMessages({
    required String? receiverId,
  }) {
    emit(GetMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime', descending: false)
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
    });
    emit(GetMessageSuccessState());
  }

  List<PostModel> myPosts = [];
  List<String> myPostsId = [];
  List<int> myLikes = [];
  List<bool> myLikedByMe = [];
  int myCounter = 0;

  List<String> myImages = [];
  List<String> myTextOfImages = [];

  void getMyPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datetime', descending: true)
        .snapshots()
        .listen((event) {
      myPosts = [];
      myPostsId = [];
      myLikes = [];
      myLikedByMe = [];
      myCounter = 0;
      myImages = [];
      myTextOfImages = [];
      emit(GetMyPostSuccessState());
      event.docs.forEach((element) {
        if (element.data()['uid'] == model!.uid) {
          element.reference.collection('likes').get().then((value) {
            emit(GetMyPostSuccessState());
            myPostsId.add(element.id);
            myPosts.add(PostModel.fromJson(element.data()));
            myLikes.add(value.docs.length);
            if (element.data()['postImage'] != '') {
              myImages.add(element.data()['postImage']);
              myTextOfImages.add(element.data()['body']);
            }
            value.docs.forEach((element) {
              if (element.id == model!.uid) {
                myCounter++;
              }
            });
            if (myCounter > 0) {
              myLikedByMe.add(true);
            } else {
              myLikedByMe.add(false);
            }
            myCounter = 0;
          }).catchError((error) {
            emit(GetMyPostErrorState());
          });
        }
      });
    });
  }

  List<PostModel> personPosts = [];
  List<String> personPostsId = [];
  List<int> personLikes = [];
  List<int> personComments = [];
  List<String> personImages = [];
  List<String> personTexts = [];
  List<bool> personIsLikedByMe =[];
  int personPostCounter =0;

  void getPersonPosts({required String? personUid}) {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datetime', descending: true)
        .snapshots()
        .listen((event) {
      personPosts = [];
      personPostsId = [];
      personLikes = [];
      personComments = [];
      personImages = [];
      personTexts = [];
      personIsLikedByMe =[];
      personPostCounter =0;
      emit(GetPersonPostSuccessState());
      event.docs.forEach((element) {
        if (element.data()['uid'] == personUid) {
          element.reference.collection('likes').get().then((value) {
            emit(GetPersonPostSuccessState());
            personPostsId.add(element.id);
            personPosts.add(PostModel.fromJson(element.data()));
            personLikes.add(value.docs.length);
            if (element.data()['postImage'] != '') {
              personImages.add(element.data()['postImage']);
              personTexts.add(element.data()['body']);
            }
            value.docs.forEach((element) {
              if (element.id == model!.uid) {
                personPostCounter++;
              }
            });
            if (personPostCounter > 0) {
              personIsLikedByMe.add(true);
            } else {
              personIsLikedByMe.add(false);
            }
            personPostCounter = 0;

          }).catchError((error) {
            emit(GetPersonPostErrorState());
          });

          element.reference.collection('comments').get().then((value) {
            emit(GetPersonPostSuccessState());
            personComments.add(value.docs.length);
          }).catchError((error) {
            emit(GetPersonPostErrorState());
          });
        }
      });
    });
  }

  void disLikePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(model!.uid)
        .delete()
        .then((value) {
      emit(DisLikeSuccessState());
    }).catchError((error) {
      emit(DisLikeErrorState());
      print(error.toString());
    });
  }

  // trying to check is liked or not but it called over
  // bool? isLiked(String? postId) {
  //   FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(postId)
  //       .collection('likes')
  //       .doc(model!.uid)
  //       .get().then((value) {
  //     emit(GetLikeSuccessState());
  //     LikeModel like = LikeModel.fromJson(value.data());
  //     print(value.data());
  //     return like.like;
  //
  //   }).catchError((error) {
  //     emit(GetLikeErrorState());
  //     print(error.toString());
  //   });
  // }

  void sendComment({
    required String? dateTime,
    required String? text,
    required String? postUid,
  }) {
    CommentModel comment = CommentModel(
        dateTime: dateTime,
        senderId: model!.uid,
        text: text,
        profileImage: model!.profileImage,
        commenterName: model!.name);

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .collection('comments')
        .add(comment.toMap())
        .then((value) {
      emit(SendCommentSuccessState());
    }).catchError((error) {
      emit(SendCommentErrorState());
      print(error.toString());
    });
  }

  List<CommentModel> comments = [];
  void getComments({
    required String? postUid,
  }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postUid)
        .collection('comments')
        .orderBy('dateTime', descending: false)
        .snapshots()
        .listen((event) {
      comments = [];
      event.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
      });
    });
    emit(GetCommentsSuccessState());
  }

  UserModel? userForRecentMessage;
  List<RecentMessageModel> recentMessages = [];
  void getRecentMessages() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recentMessages')
        .orderBy('dateTimeOfLastMessage', descending: true)
        .snapshots()
        .listen((event) {
      recentMessages = [];
      event.docs.forEach((element) {
        recentMessages.add(RecentMessageModel.fromJson(element.data()));
      });
    });
    emit(GetRecentMessagesSuccessState());
  }

  void sendNotifications({
    required String? action,
    required String? targetPostUid,
    required String? receiverUid,
    required String? dateTime,
  }) {
    if (receiverUid != model!.uid) {
      NotificationModel notify = NotificationModel(
          action: action,
          receiverUid: receiverUid,
          senderName: model!.name,
          senderProfileImage: model!.profileImage,
          senderUid: model!.uid,
          targetPostUid: targetPostUid,
          dateTime: dateTime,
          seen: false);

      FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUid)
          .collection('notifications')
          .add(notify.toMap())
          .then((value) {
        emit(SendNotificationsSuccessState());
      }).catchError((error) {
        emit(SendNotificationsErrorState());
      });
    }
  }

  void notificationSeen()
  {

  }
  List<NotificationModel> myNotifications = [];
  void getNotifications() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      myNotifications = [];
      event.docs.forEach((element) {
        myNotifications.add(NotificationModel.fromJson(element.data()));
      });
    });
    emit(GetNotificationsSuccessState());
  }

  PostModel? singlePost;
  int singlePostLikes = 0;
  bool? singlePostIsLikedByMe;
  int singlePostCounter = 0;

  void getSinglePost({required postId}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((firstValue) {
      firstValue.reference.collection('likes').get().then((value) {
        emit(GetPostSuccessState());
        //reset counter
        singlePostCounter = 0;
        //fill
        singlePostLikes = value.docs.length;
        singlePost = PostModel.fromJson(firstValue.data());
        value.docs.forEach((element) {
          if (element.id == uid) {
            singlePostCounter = (singlePostCounter + 1);
          }
          if (singlePostCounter > 0) {
            singlePostIsLikedByMe = true;
          } else {
            singlePostIsLikedByMe = false;
          }
        });
      }).catchError((error) {});

      emit(GetPostErrorState());
    }).catchError((error) {
      emit(GetPostErrorState());
    });
  }

  void setRecentMessage(
      {required String? receiverId,
      required String? dateTimeOfLastMessage,
      required String? lastMessage,
      required String? receiverName,
      required String? receiverProfilePic}) {
    RecentMessageModel recentMessage = RecentMessageModel(
      senderId: model!.uid,
      dateTimeOfLastMessage: dateTimeOfLastMessage,
      lastMessage: lastMessage,
      senderName: model!.name,
      senderProfilePic: model!.profileImage,
      receiverId: receiverId,
      receiverName: receiverName,
      receiverProfilePic: receiverProfilePic,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(model!.uid)
        .collection('recentMessages')
        .doc(receiverId)
        .set(recentMessage.toMap())
        .then((value) {
      emit(SetRecentMessageSuccessState());
    }).catchError((error) {
      emit(SetRecentMessageErrorState());
      print(error.toString());
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('recentMessages')
        .doc(model!.uid)
        .set(recentMessage.toMap())
        .then((value) {
      emit(SetRecentMessageSuccessState());
    }).catchError((error) {
      emit(SetRecentMessageErrorState());
      print(error.toString());
    });
  }


  void deletePost(String? postId){
    FirebaseFirestore.instance.collection('posts').doc(postId).delete().then((value) {
      emit(DeletePostSuccessState());
    }).catchError((error){
      print('error delete post');
    });

  }

  void deleteChat(String? personId){
    FirebaseFirestore.instance.collection('users').doc(uid).collection('chats').doc(personId).delete().then((value) {
      emit(DeleteChatSuccessState());
    }).catchError((error){
      print(error.toString());
    });
    FirebaseFirestore.instance.collection('users').doc(uid).collection('recentMessages').doc(personId).delete().then((value) {
      emit(DeleteChatSuccessState());
    }).catchError((error){
      print(error.toString());
    });

  }
}
