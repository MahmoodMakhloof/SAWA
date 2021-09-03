import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:social/models/comment_model.dart';

import 'package:social/shared/components/constants.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';

import 'package:social/shared/style/icon_broken.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

class CommentsScreen extends StatefulWidget {
  final String? postUid;
  final String? receiverUid;
  CommentsScreen(this.postUid, this.receiverUid);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  var commentController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SocialCubit cubit = SocialCubit.get(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              IconBroken.Arrow___Left_2,
              color: BROWN,
            ),
          ),
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark),
          elevation: 0,
          backgroundColor: GREEN.withOpacity(0.4),
          backwardsCompatibility: false,
          titleSpacing: 5,
          title: Text(
            'Comments',
            style: TextStyle(
              color: BROWN,
            ),
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postUid)
                .collection('comments')
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
                cubit.comments = [];
                snapshot.data.docs.forEach((element) {
                  cubit.comments.add(CommentModel.fromJson(element.data()));
                });
                return Conditional.single(
                    context: context,
                    conditionBuilder: (BuildContext context) =>
                        snapshot.hasData == true &&
                        cubit.comments.length > 0 == true,
                    widgetBuilder: (BuildContext context) => Column(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                physics: BouncingScrollPhysics(),
                                reverse: false,
                                itemBuilder: (context, index) {
                                  return buildComment(cubit.comments[index]);
                                },
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 0,
                                ),
                                itemCount: cubit.comments.length,
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
                                            hintText: 'comment..',
                                          ),
                                          autocorrect: true,
                                          controller: commentController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'The comment can\'t be empty';
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
                                            print('comment');
                                            SocialCubit.get(context)
                                                .sendComment(
                                                    dateTime: DateTime.now()
                                                        .toString(),
                                                    text:
                                                        commentController.text,
                                                    postUid: widget.postUid);
                                            SocialCubit.get(context)
                                                .sendNotifications(
                                                action: 'COMMENT',
                                                targetPostUid: widget.postUid,
                                                receiverUid: widget.receiverUid,
                                                dateTime: DateTime.now()
                                                    .toString());
                                            commentController.text = '';
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
                              child: Center(
                                  child: Text(
                                      'No comments yet,\nPut your comment')),
                            )),
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
                                            hintText: 'comment..',
                                          ),
                                          autocorrect: true,
                                          controller: commentController,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'The comment can\'t be empty';
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
                                            print('comment');
                                            SocialCubit.get(context)
                                                .sendComment(
                                                    dateTime: DateTime.now()
                                                        .toString(),
                                                    text:
                                                        commentController.text,
                                                    postUid: widget.postUid);
                                            SocialCubit.get(context)
                                                .sendNotifications(
                                                    action: 'COMMENT',
                                                    targetPostUid: widget.postUid,
                                                    receiverUid: widget.receiverUid,
                                                    dateTime: DateTime.now()
                                                        .toString());
                                            commentController.text = '';
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

  Widget buildComment(CommentModel comment) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
            ),
            child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                '${comment.profileImage}',
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  color: Colors.grey.withOpacity(0.2)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${comment.commenterName}',
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 17,
                          color: BROWN,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${comment.text}',
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
