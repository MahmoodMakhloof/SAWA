import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/modules/chat_screen/chat_screen.dart';
import 'package:social/modules/profile/profile.dart';
import 'package:social/modules/search_screen/search_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';
import 'package:social/shared/social_cubit/social_states.dart';
import 'package:social/shared/style/icon_broken.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class SocialLayoutScreen extends StatefulWidget {
  final bool afterLoginOrRegister;

  const SocialLayoutScreen({Key? key, required this.afterLoginOrRegister}) : super(key: key);
  @override
  _SocialLayoutScreenState createState() => _SocialLayoutScreenState(afterLoginOrRegister);
}

class _SocialLayoutScreenState extends State<SocialLayoutScreen> {
  var pageController = PageController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  final bool afterLoginOrRegister;

  _SocialLayoutScreenState(this.afterLoginOrRegister);

  @override
  Widget build(BuildContext context) {

    return Builder(
      builder: (context) {
        if(afterLoginOrRegister ==true)
          {
            SocialCubit.get(context).getUserData();
            SocialCubit.get(context).getPosts();
            SocialCubit.get(context).getMyPosts();
            SocialCubit.get(context).getAllUsers();
            SocialCubit.get(context).getNotifications();
            SocialCubit.get(context).getRecentMessages();
          }

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            SocialCubit cubit = SocialCubit.get(context);

            return Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.white,
              drawer: Padding(
                padding: const EdgeInsets.only(
                  bottom: 90,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(35)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Drawer(
                    child: cubit.model != null
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                if (true)
                                  DrawerHeader(
                                    curve: Curves.easeInCirc,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [GREEN, YELLOW, Colors.white],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter)),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundImage: NetworkImage(
                                                '${cubit.model!.profileImage}',
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${cubit.model!.name}',
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: BROWN,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${cubit.model!.email}',
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: ORANGE),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ListTile(
                                  title: Text(
                                    'Home',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  leading: Icon(IconBroken.Home),
                                ),
                                ListTile(
                                  title: Text(
                                    'Profile',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    navigateTo(context, ProfileScreen());
                                  },
                                  leading: Icon(IconBroken.Profile),
                                ),
                                ListTile(
                                  title: Text(
                                    'Setting',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onTap: () {},
                                  leading: Icon(IconBroken.Setting),
                                ),
                                ListTile(
                                  title: Text(
                                    'Log out',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  onTap: () {
                                    logOut(context);
                                  },
                                  leading: Icon(IconBroken.Logout),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: CircularProgressIndicator(
                            color: GREEN,
                          )),
                  ),
                ),
              ),
              appBar: AppBar(
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu_outlined, size: 25, color: BROWN),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                centerTitle: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark),
                elevation: 0,
                backgroundColor: GREEN.withOpacity(0.4),
                backwardsCompatibility: false,
                actions: [
                  IconButton(
                      onPressed: () {
                        print('search');
                        navigateTo(context, SearchScreen());
                      },
                      icon: Icon(IconBroken.Search, color: BROWN)),
                  IconButton(
                      onPressed: () {
                        print('massenger');
                        navigateTo(context, ChatScreen());
                      },
                      icon: Icon(IconBroken.Send, color: BROWN)),
                ],
                title: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    'SAWA',
                    style: TextStyle(
                        color: BROWN, fontSize: 21, fontWeight: FontWeight.w700),
                  ),
                ),
                titleSpacing: 3,
              ),
              body: cubit.model != null
                  ? PageView(
                      physics: BouncingScrollPhysics(),
                      children: cubit.bottomNavBarScreens,
                      onPageChanged: (index) {
                        cubit.changeBottomNavBarCurrentIndex(index);
                      },
                      controller: pageController,
                    )
                  : Center(
                      child: CircularProgressIndicator(
                      color: GREEN,
                    )),
              bottomNavigationBar: CurvedNavigationBar(
                height: 60,
                onTap: (index) {
                  cubit.changeBottomNavBarCurrentIndex(index);
                  pageController.jumpToPage(index);
                },
                color: GREEN.withOpacity(0.4),
                index: cubit.bottomNavBarCurrentIndex,
                backgroundColor: Colors.transparent,
                items: <Widget>[
                  Icon(
                    IconBroken.Home,
                    size: 20,
                    color: BROWN,
                  ),
                  Icon(IconBroken.Notification, size: 20, color: BROWN),
                  Icon(
                    IconBroken.User1,
                    size: 20,
                    color: BROWN,
                  ),
                ],
              ),
            );
          },
        );
      }
    );
  }
}
