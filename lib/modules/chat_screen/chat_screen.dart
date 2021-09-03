import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/modules/chat_screen/friends_screen/friends_screen.dart';
import 'package:social/modules/chat_screen/recent_messages_screen/recent_messages_screen.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';
import 'package:social/shared/social_cubit/social_states.dart';
import 'package:social/shared/style/icon_broken.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Widget> chatScreens = [
    RecentMessagesScreen(),
    FriendsScreen(),
  ];

  int currentIndex = 0;

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
                        '${SocialCubit.get(context).model!.profileImage}',
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                'Chats',
                style: TextStyle(
                  color: BROWN,
                ),
              ),
            ),
            body: chatScreens[currentIndex],
            bottomNavigationBar: CurvedNavigationBar(
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              items: [
                Icon(IconBroken.Message),
                Icon(IconBroken.User),
              ],
              height: 60,
              color: GREEN.withOpacity(0.3),
              backgroundColor: Colors.white,
            ),
          );
        },
        listener: (context, state) {});
  }
}
