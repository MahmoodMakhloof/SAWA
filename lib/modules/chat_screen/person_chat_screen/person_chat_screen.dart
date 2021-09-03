import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';
import 'package:social/shared/social_cubit/social_states.dart';
import 'package:social/shared/style/icon_broken.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class PersonChatScreen extends StatelessWidget {
  UserModel? user;
  PersonChatScreen(this.user);

  var messageController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SocialCubit cubit = SocialCubit.get(context);
    return Scaffold(
        appBar: AppBar(
            centerTitle: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark),
            elevation: 0,
            backgroundColor: GREEN.withOpacity(0.4),
            backwardsCompatibility: false,
            titleSpacing: 5,
            leading: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 5, top: 5, bottom: 5, right: 5),
                  child: CircleAvatar(
                    radius: 17,
                    backgroundImage: NetworkImage(
                      '${user!.profileImage}',
                    ),
                  ),
                ),
              ],
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user!.name}',
                  style: TextStyle(
                    color: BROWN,
                  ),
                ),
                if(false)
                  Text(
                  'online',
                  style: TextStyle(
                      fontSize: 7, color: BROWN, fontWeight: FontWeight.bold),
                )
              ],
            )),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(cubit.model!.uid)
                .collection('chats')
                .doc(user!.uid)
                .collection('messages')
                .orderBy('dateTime', descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: GREEN,
                  ),
                );
              } else {
                cubit.messages = [];
                snapshot.data.docs.forEach((element) {
                  cubit.messages.add(MessageModel.fromJson(element.data()));
                });
                return Conditional.single(
                    context: context,
                    conditionBuilder: (BuildContext context) =>
                        snapshot.hasData == true &&
                        cubit.messages.length > 0 == true,
                    widgetBuilder: (BuildContext context) => Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                reverse: true,
                                itemBuilder: (context, index) {
                                  var message = cubit.messages[index];
                                  if (cubit.model!.uid == message.senderId) {
                                    return buildMyMessage(message);
                                  } else {
                                    return buildFriendMessage(message);
                                  }
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 0,
                                ),
                                itemCount:
                                    SocialCubit.get(context).messages.length,
                              ),
                            ),
                            Container(
                              color: GREEN.withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5),
                                child: Form(
                                  key: formKey,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 0, right: 7),
                                          child: Transform.rotate(
                                              angle: 0,
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      GREEN.withOpacity(0.1),
                                                  child: Icon(
                                                    IconBroken.Image,
                                                    size: 20,
                                                  ))),
                                        ),
                                        onPressed: () {
                                          print('add image');
                                        },
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          autofocus: false,
                                          keyboardType: TextInputType.text,
                                          enableInteractiveSelection: true,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                          enableSuggestions: true,
                                          scrollPhysics:
                                              BouncingScrollPhysics(),
                                          decoration: InputDecoration(
                                            icon: SizedBox(
                                              width: 5,
                                            ),
                                            focusedBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            border: InputBorder.none,
                                            fillColor: Colors.grey,
                                            hintText: 'write your message..',
                                          ),
                                          autocorrect: true,
                                          controller: messageController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'The message can\'t be empty';
                                            }
                                            return null;
                                          },
                                          onFieldSubmitted: (value) {},
                                        ),
                                      ),
                                      IconButton(
                                        icon: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 0, right: 7),
                                          child: Transform.rotate(
                                              angle: 2400,
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      GREEN.withOpacity(0.1),
                                                  child: Icon(
                                                    IconBroken.Send,
                                                    size: 20,
                                                  ))),
                                        ),
                                        onPressed: () {
                                          if (formKey.currentState!
                                                  .validate() ==
                                              true) {
                                            print('send');
                                            SocialCubit.get(context)
                                                .sendMessage(
                                                    receiverId: user!.uid,
                                                    dateTime: DateTime.now()
                                                        .toString(),
                                                    text:
                                                        messageController.text);
                                            cubit.setRecentMessage(
                                                receiverId: user!.uid,
                                                dateTimeOfLastMessage:
                                                    DateTime.now().toString(),
                                                lastMessage:
                                                    messageController.text,
                                                receiverName: user!.name,
                                                receiverProfilePic:
                                                    user!.profileImage);
                                            messageController.text = '';
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    fallbackBuilder: (BuildContext context) => Column(
                          children: [
                            Expanded(
                                child: Container(
                                    child: Center(child: Text('Say Hello')))),
                            Container(
                              color: GREEN.withOpacity(0.3),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5),
                                child: Form(
                                  key: formKey,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 0, right: 7),
                                          child: Transform.rotate(
                                              angle: 0,
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      GREEN.withOpacity(0.1),
                                                  child: Icon(
                                                    IconBroken.Image,
                                                    size: 20,
                                                  ))),
                                        ),
                                        onPressed: () {
                                          print('add image');
                                        },
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          autofocus: false,
                                          keyboardType: TextInputType.text,
                                          enableInteractiveSelection: true,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                          enableSuggestions: true,
                                          scrollPhysics:
                                              BouncingScrollPhysics(),
                                          decoration: InputDecoration(
                                            icon: SizedBox(
                                              width: 5,
                                            ),
                                            focusedBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            border: InputBorder.none,
                                            fillColor: Colors.grey,
                                            hintText: 'write your message..',
                                          ),
                                          autocorrect: true,
                                          controller: messageController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'The message can\'t be empty';
                                            }
                                            return null;
                                          },
                                          onFieldSubmitted: (value) {},
                                        ),
                                      ),
                                      IconButton(
                                        icon: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 0, right: 7),
                                          child: Transform.rotate(
                                              angle: 2400,
                                              child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor:
                                                      GREEN.withOpacity(0.1),
                                                  child: Icon(
                                                    IconBroken.Send,
                                                    size: 20,
                                                  ))),
                                        ),
                                        onPressed: () {
                                          if (formKey.currentState!
                                                  .validate() ==
                                              true) {
                                            print('send');
                                            SocialCubit.get(context)
                                                .sendMessage(
                                                    receiverId: user!.uid,
                                                    dateTime: DateTime.now()
                                                        .toString(),
                                                    text:
                                                        messageController.text);
                                            cubit.setRecentMessage(
                                                receiverId: user!.uid,
                                                dateTimeOfLastMessage:
                                                    DateTime.now().toString(),
                                                lastMessage:
                                                    messageController.text,
                                                receiverName: user!.name,
                                                receiverProfilePic:
                                                    user!.profileImage);
                                            messageController.text = '';
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ));
              }
            }));
  }

  Widget buildFriendMessage(MessageModel message) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Padding(
        padding: const EdgeInsets.only(right: 40, left: 10, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: YELLOW.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              '${message.text}',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMyMessage(MessageModel message) {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: Padding(
        padding: const EdgeInsets.only(right: 10, left: 40, bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            color: ORANGE.withOpacity(0.3),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              '${message.text}',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
