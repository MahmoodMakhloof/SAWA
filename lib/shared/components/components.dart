import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social/models/message_model.dart';
import 'package:social/models/notification_model.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/recent_messages_model.dart';
import 'package:social/models/user_model.dart';
import 'package:social/modules/chat_screen/person_chat_screen/person_chat_screen.dart';
import 'package:social/modules/comments_screen/comments_screen.dart';
import 'package:social/modules/image_view_screen/image_view_screen.dart';
import 'package:social/modules/login_screen/login_screen.dart';
import 'package:social/modules/person_profile/person_profile.dart';
import 'package:social/modules/profile/profile.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/network/local/cache_helper.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';
import 'package:social/shared/style/icon_broken.dart';

Widget defaultButton({
  double width = double.infinity,
  Color color = Colors.blue,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
        ),
        child: MaterialButton(
          color: color,
          onPressed: () {
            function();
          },
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

Widget defaultTextField({
  required TextEditingController controller,
  bool isPassword = false,
  required TextInputType type,
  Function? onSubmit,
  Function? onTap,
  required String text,
  required IconData prefix,
  IconData? suffix,
  Function? suffixFunction,
  String textForUnValid = 'this element is required',
  //required Function validate,
}) =>
    Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      child: Container(
        height: 80,
        decoration: BoxDecoration(),
        child: TextFormField(
          enableSuggestions: true,
          autocorrect: true,
          controller: controller,
          onTap: () {
            onTap!();
          },
          validator: (value) {
            if (value!.isEmpty) {
              return textForUnValid;
            }
            return null;
          },
          onChanged: (value) {},
          onFieldSubmitted: (value) {
            onSubmit!(value);
          },
          obscureText: isPassword ? true : false,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            labelText: text,
            prefixIcon: Icon(prefix),
            suffixIcon: IconButton(
              onPressed: () {
                suffixFunction!();
              },
              icon: Icon(suffix),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: const BorderSide(),
                gapPadding: 4),
          ),
        ),
      ),
    );

void navigateTo(context, widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false);
}

void showToast({
  required String? msg,
  required ToastState state,
}) {
  Fluttertoast.showToast(
      msg: msg!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.black.withOpacity(0.5),
      textColor: chooseToastColor(state),
      fontSize: 14.0);
}

enum ToastState {
  SUCCESS,
  ERROR,
  WARNING,
}

Color chooseToastColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.SUCCESS:
      color = GREEN;
      break;

    case ToastState.ERROR:
      color = RED;
      break;

    case ToastState.WARNING:
      color = ORANGE;
      break;
  }
  return color;
}

void logOut(context) {
  CacheHelper.removeData(key: 'uid');
  SocialCubit.get(context).model = null;
  uid = '';
  SocialCubit.get(context).users = [];
  SocialCubit.get(context).myNotifications =[];
  SocialCubit.get(context).recentMessages =[];


  navigateAndFinish(context, LoginScreen());
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

// post builder
Widget singlePostBuilder(PostModel post, context, index) {
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
                SocialCubit.get(context).getAllPersonUsers(personUid: post.uid);
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
                        '${post.datetime!.substring(0,16)}',
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
              padding:
                  const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${post.body}',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.5),
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
              decoration: BoxDecoration(

              ),
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
                  Text('${SocialCubit.get(context).likes[index]}'),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  // Text('${SocialCubit.get(context).commentsNumber[index]} comments'),
                  InkWell(
                      onTap: () {
                        navigateTo(
                            context,
                            CommentsScreen(
                                SocialCubit.get(context).postsId[index],post.uid));
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
                              context,
                              CommentsScreen(
                                  SocialCubit.get(context).postsId[index],post.uid));
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
                      if (SocialCubit.get(context).likedByMe[index] == true) {
                        SocialCubit.get(context).disLikePost(
                            SocialCubit.get(context).postsId[index]);
                        SocialCubit.get(context).likedByMe[index] = false;
                        SocialCubit.get(context).likes[index]--;
                      } else {
                        SocialCubit.get(context)
                            .likePost(SocialCubit.get(context).postsId[index]);
                        SocialCubit.get(context).likedByMe[index] = true;
                        SocialCubit.get(context).likes[index]++;
                        //send notification to post owner with your like
                        SocialCubit.get(context).sendNotifications(
                            action: 'LIKE',
                            targetPostUid:
                                SocialCubit.get(context).postsId[index],
                            receiverUid: post.uid,
                            dateTime: DateTime.now().toString());
                      }
                    },
                    icon: Icon(
                      IconBroken.Heart,
                      color: SocialCubit.get(context).likedByMe[index] == true
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

// my post builder
Widget singleMyPostBuilder(PostModel post, context, index) {
  return Dismissible(
    direction: DismissDirection.startToEnd,
    background: Container(
      color: RED.withOpacity(0.5),
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete_outline_outlined,color: Colors.white,),
      ),
    ),
    key: ObjectKey(index),
    onDismissed: (direction){
      SocialCubit.get(context).deletePost(SocialCubit.get(context).myPostsId[index]);
    },

    child: Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(left: 5, right: 5),
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
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
                        '${post.datetime!.substring(0,16)}',
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
          if (post.body != '')
            Padding(
                padding:
                    const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${post.body}',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15.5),
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
                navigateTo(context,
                    ImageViewScreen(image: post.postImage, body: post.body));
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
                    Text('${SocialCubit.get(context).myLikes[index]}'),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          navigateTo(
                              context,
                              CommentsScreen(
                                  SocialCubit.get(context).myPostsId[index],post.uid));
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
                                context,
                                CommentsScreen(
                                    SocialCubit.get(context).myPostsId[index],post.uid));
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
                        if (SocialCubit.get(context).myLikedByMe[index] == true) {
                          SocialCubit.get(context).disLikePost(
                              SocialCubit.get(context).myPostsId[index]);
                          SocialCubit.get(context).myLikedByMe[index] = false;
                          SocialCubit.get(context).myLikes[index]--;
                        } else {
                          SocialCubit.get(context).likePost(
                              SocialCubit.get(context).myPostsId[index]);
                          SocialCubit.get(context).myLikedByMe[index] = true;
                          SocialCubit.get(context).myLikes[index]++;
                        }
                      },
                      icon: Icon(
                        IconBroken.Heart,
                        color: SocialCubit.get(context).myLikedByMe[index] == true
                            ? Colors.red
                            : null,
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// person post
Widget singlePersonPostBuilder(PostModel post, context, index) {
  return Card(
    clipBehavior: Clip.antiAlias,
    margin: EdgeInsets.only(left: 5, right: 5),
    elevation: 10,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
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
                      '${post.datetime!.substring(0,16)}',
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
        Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, bottom: 8, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${post.body}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15.5),
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
            onTap: (){
              navigateTo(context,ImageViewScreen(image: post.postImage, body: post.body));
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
                  Text('${SocialCubit.get(context).personLikes[index]}'),
                ],
              ),
              Spacer(),
              Row(
                children: [
                  InkWell(
                    onTap: (){
                      navigateTo(context, CommentsScreen(
                        SocialCubit.get(context).personPostsId[index],SocialCubit.get(context).personModel!.uid
                      ));
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
                          navigateTo(context, CommentsScreen(
                              SocialCubit.get(context).personPostsId[index],SocialCubit.get(context).personModel!.uid
                          ));
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
                      if (SocialCubit.get(context).personIsLikedByMe[index] == true) {
                        SocialCubit.get(context).disLikePost(
                            SocialCubit.get(context).personPostsId[index]);
                        SocialCubit.get(context).personIsLikedByMe[index] = false;
                        SocialCubit.get(context).personLikes[index]--;
                      } else {
                        SocialCubit.get(context).likePost(
                            SocialCubit.get(context).personPostsId[index]);
                        SocialCubit.get(context).personIsLikedByMe[index] = true;
                        SocialCubit.get(context).personLikes[index]++;
                      }
                    },
                    icon: Icon(IconBroken.Heart,color:SocialCubit.get(context).personIsLikedByMe[index] == true
                        ? Colors.red
                        : null,)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
//replace every single follower by single user for inkwell is ready there
Widget singleFollowerBuilder(UserModel user,context) => Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundImage: NetworkImage(
              '${user.profileImage}',
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
                  '${user.name}',
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 17, color: BROWN, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${SocialCubit.get(context).users.length-1} mutual friends',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 9, color: GREEN, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          // IconButton(
          //     onPressed: () {},
          //     icon: Icon(
          //       IconBroken.Arrow___Down_2,
          //       color: BROWN,
          //     ))

          optionIcon(function: () {
            print('option');
          }),
        ],
      ),
    );

Widget singleUserBuilder(UserModel user, BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: InkWell(
        onTap: () {
          if (user.uid == uid) {
            navigateTo(context, ProfileScreen());
          } else {
            SocialCubit.get(context).getAllPersonUsers(personUid: user.uid);
            SocialCubit.get(context).getAnotherPersonData(personUid: user.uid);
            SocialCubit.get(context).getPersonPosts(personUid: user.uid);
            navigateTo(
                context,
                PersonProfileScreen(
                  personUid: user.uid,
                ));
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(
                '${user.profileImage}',
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
                    '${user.name}',
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 17,
                        color: BROWN,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${SocialCubit.get(context).users.length - 1} mutual friends',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 9, color: GREEN, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  IconBroken.User,
                  color: BROWN,
                ))
          ],
        ),
      ),
    );

Widget onlinePersonBuilder(UserModel user, context) {
  return InkWell(
    onTap: () {
      navigateTo(context, PersonChatScreen(user));
    },
    child: Container(
      width: 80,
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  '${user.profileImage}',
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 9,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: GREEN,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 7,
          ),
          Text(
            '${user.name}',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: BROWN,
                height: 1.2),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}

Widget personMessage(
     RecentMessageModel r,context,index,) {
  return Dismissible(
    background: Container(
      color: GREEN.withOpacity(0.5),
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Icon(Icons.archive,color: Colors.white,),
      ),
    ),
    secondaryBackground: Container(
      color: RED.withOpacity(0.5),
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Icon(Icons.delete_outline_outlined,color: Colors.white,),
      ),
    ),
    key: ObjectKey(index),
    onDismissed: (direction){
      switch(direction)
      {
        case DismissDirection.startToEnd:
          break;
        case DismissDirection.endToStart:
          SocialCubit.get(context).deleteChat(r.receiverId==uid?r.senderId:r.receiverId);
          break;
      }
    },
    child: InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection('users').doc(r.receiverId==uid?r.senderId:r.receiverId).get().then((value) {
          SocialCubit.get(context).userForRecentMessage=UserModel.fromJson(value.data());
        }).then((value) {
          navigateTo(context, PersonChatScreen(SocialCubit.get(context).userForRecentMessage));
        });

      },
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(
                '${r.receiverId==uid?r.senderProfilePic:r.receiverProfilePic}',
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
                    '${r.receiverId==uid?r.senderName:r.receiverName}',
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 17, color: BROWN, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 200,
                        child: Text(
                          '${r.receiverId==uid?r.lastMessage:r.lastMessage}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              color: r.receiverId==uid?GREEN:Colors.black54,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            '${r.dateTimeOfLastMessage!.substring(11,16)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 9,
                                color: BROWN,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget optionIcon({required Function function}) {
  return InkWell(
    onTap: () {
      function();
    },
    child: Container(
      height: 40,
      width: 40,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: BROWN,
              radius: 1.5,
            ),
            SizedBox(
              width: 1,
            ),
            CircleAvatar(
              backgroundColor: BROWN,
              radius: 1.5,
            ),
            SizedBox(
              width: 1,
            ),
            CircleAvatar(
              backgroundColor: BROWN,
              radius: 1.5,
            ),
          ],
        ),
      ),
    ),
  );
}
