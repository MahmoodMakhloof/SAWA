import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/models/post_model.dart';
import 'package:social/modules/comments_screen/comments_screen.dart';
import 'package:social/modules/image_view_screen/image_view_screen.dart';
import 'package:social/modules/person_profile/person_profile.dart';
import 'package:social/modules/profile/profile.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';
import 'package:social/shared/social_cubit/social_states.dart';
import 'package:social/shared/style/icon_broken.dart';

class SinglePostViewScreen extends StatefulWidget {
  final String? postUid;
  const SinglePostViewScreen({Key? key, this.postUid}) : super(key: key);

  @override
  _SinglePostViewScreenState createState() =>
      _SinglePostViewScreenState(postUid!);
}

class _SinglePostViewScreenState extends State<SinglePostViewScreen> {
  final String? postUid;

  _SinglePostViewScreenState(this.postUid);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark),
              elevation: 0,
              backgroundColor: GREEN.withOpacity(0.4),
              backwardsCompatibility: false,
              leading: IconButton(
                icon: Icon(
                  IconBroken.Arrow___Left_2,
                  color: BROWN,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text(
                'Posts',
                style: TextStyle(color: BROWN),
              ),
            ),
            body: Builder(
              builder: (context) {
                return SocialCubit.get(context).singlePost != null
                    ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                        child: singlePost(
                            SocialCubit.get(context).singlePost!, context))
                    : Center(
                        child: CircularProgressIndicator(
                        color: GREEN,
                      ));
              },
            ),
          );
        },
        listener: (context, state) {});
  }

  Widget singlePost(
    PostModel post,
    context,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(left: 5, right: 5),
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () {
                if (post.uid == uid) {
                  navigateTo(context, ProfileScreen());
                } else {
                  SocialCubit.get(context)
                      .getAllPersonUsers(personUid: post.uid);
                  SocialCubit.get(context)
                      .getAnotherPersonData(personUid: post.uid);
                  SocialCubit.get(context).getPersonPosts(personUid: post.uid);
                  navigateTo(
                      context,
                      PersonProfileScreen(
                        personUid: post.uid,
                      ));
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(
                      '${post.profileImage}',
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${post.name}',
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              color: BROWN,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${post.datetime}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 9,
                              color: GREEN,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          if (post.body != '')
            Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, bottom: 8, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${post.body}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.5),
                    ),
                    // Wrap(
                    //   // alignment: WrapAlignment.start,
                    //   children: [
                    //     TextButton(
                    //         onPressed: () {},
                    //         child: Text(
                    //           '#fashion',
                    //           style: TextStyle(color: GREEN),
                    //         )),
                    //     TextButton(
                    //         onPressed: () {},
                    //         child: Text(
                    //           '#girls',
                    //           style: TextStyle(color: GREEN),
                    //         )),
                    //     TextButton(
                    //         onPressed: () {},
                    //         child: Text(
                    //           '#cofee',
                    //           style: TextStyle(color: GREEN),
                    //         )),
                    //   ],
                    // ),
                  ],
                )),
          if (post.postImage != '')
            InkWell(
              onTap: () {
                navigateTo(
                    context,
                    ImageViewScreen(
                      image: post.postImage,
                      body: post.body,
                    ));
              },
              child: Container(
                height: 300,
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: Image(
                  image: NetworkImage('${post.postImage}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(
                      IconBroken.Heart,
                      color: RED,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('${SocialCubit.get(context).singlePostLikes}'),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    // Text('${SocialCubit.get(context).commentsNumber[index]} comments'),
                    InkWell(
                        onTap: () {
                          navigateTo(
                              context, CommentsScreen(postUid, post.uid));
                        },
                        child: Text('Comments')),
                  ],
                ),
              ],
            ),
          ),
          Card(
            elevation: 5,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.only(
              left: 0,
              right: 0,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(
                      '${SocialCubit.get(context).model!.profileImage}',
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            print('comment');
                            navigateTo(
                                context, CommentsScreen(postUid, post.uid));
                          },
                          child: Text(
                            'comment..',
                            textAlign: TextAlign.start,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 15,
                                color: BROWN,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(IconBroken.Upload)),
                  IconButton(
                      onPressed: () {
                        if (SocialCubit.get(context).singlePostIsLikedByMe ==
                            true) {
                          SocialCubit.get(context).disLikePost(postUid!);
                          SocialCubit.get(context).singlePostIsLikedByMe =
                              false;
                          SocialCubit.get(context).singlePostLikes--;
                        } else {
                          SocialCubit.get(context).likePost(postUid!);
                          SocialCubit.get(context).singlePostIsLikedByMe = true;
                          SocialCubit.get(context).singlePostLikes++;
                          //send notification to post owner with your like
                          SocialCubit.get(context).sendNotifications(
                              action: 'LIKE',
                              targetPostUid: postUid,
                              receiverUid: post.uid,
                              dateTime: DateTime.now().toString());
                        }
                      },
                      icon: Icon(
                        IconBroken.Heart,
                        color: SocialCubit.get(context).singlePostIsLikedByMe ==
                                true
                            ? Colors.red
                            : null,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
