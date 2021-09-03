import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/modules/login_screen/login_cubit/cubit.dart';
import 'package:social/modules/register_screen/register_cubit/cubit.dart';
import 'package:social/shared/bloc_observer.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/network/local/cache_helper.dart';
import 'package:social/shared/network/remote/dio_helper.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';
import 'package:social/shared/social_cubit/social_states.dart';

import 'layout/social_layout_screen.dart';
import 'modules/login_screen/login_screen.dart';
import 'modules/on_boarding_screen/on_boarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'modules/register_screen/male_or_female_screen/male_or_female_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  DioHelper.dioInit();
  await CacheHelper.init();
  bool? onBoarding = CacheHelper.importData(key: 'onBoarding');
  uid = CacheHelper.importData(key: 'uid') != null
      ? CacheHelper.importData(key: 'uid')
      : null;

  late Widget startWidget = OnBoardingScreen();
  if (onBoarding != null) {
    if (uid != null) {
      startWidget = SocialLayoutScreen(
        afterLoginOrRegister: false,
      );
    } else {
      startWidget = LoginScreen();
    }
  } else {
    OnBoardingScreen();
  }

  runApp(MyApp(startWidget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  MyApp(this.startWidget);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => RegisterCubit()),
          BlocProvider(
              create: (context) => SocialCubit()
                ..getUserData()
                ..getAllUsers()
                ..getPosts()
                ..getMyPosts()..getNotifications()..getRecentMessages()
                ),
        ],
        child: BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  fontFamily: 'Nunito',
                  primarySwatch: Colors.brown,
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: Colors.white,
                    elevation: 0,
                  )),
              themeMode: ThemeMode.light,
              home: startWidget,
            );
          },
        ));
  }
}
