
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/models/notification_model.dart';
import 'package:social/modules/single_post_view/single_post_view.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';
import 'package:social/shared/social_cubit/social_states.dart';
import 'package:social/shared/style/icon_broken.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => notificationBuilder(
              SocialCubit.get(context).myNotifications[index],context),
          separatorBuilder: (context, index) => SizedBox(
            height: 0,
          ),
          itemCount: SocialCubit.get(context).myNotifications.length,
        );
      },
    );
  }
}

Widget notificationBuilder(NotificationModel notify,context) {
  return InkWell(
    onTap: ()
    {
      SocialCubit.get(context).singlePost = null;
      SocialCubit.get(context).getSinglePost(postId: notify.targetPostUid);
      navigateTo(context,SinglePostViewScreen(postUid: notify.targetPostUid,));
    },
    child: Card(
      elevation: 10,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(left: 7, right: 7, bottom: 2, top: 2),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15, right: 6, left: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundImage: NetworkImage(
                    '${notify.senderProfileImage}',
                  ),
                ),
                notify.action == 'COMMENT'
                    ? Icon(
                        Icons.mode_comment,
                        color: GREEN,
                        size: 15,
                      )
                    : Icon(
                        Icons.favorite,
                        color: RED,
                        size: 18,
                      )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${notify.senderName} ${notify.action == 'LIKE' ? 'Liked your post' : 'Commented on your post'}',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15, color: BROWN, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  IconBroken.Info_Circle,
                  color: BROWN,
                ))
          ],
        ),
      ),
    ),
  );
}
