import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/models/on_boarding.dart';
import 'package:social/modules/login_screen/login_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/network/local/cache_helper.dart';

import 'on_boarding_states.dart';

class OnBoardingCubit extends Cubit<OnBoardingStates> {
  OnBoardingCubit() : super(OnBoardingInitialStates());

  static OnBoardingCubit get(context) => BlocProvider.of(context);

  bool isLast = false;
  void changeIsLastToBeTrue() {
    isLast = true;
    emit(OnBoardingLastPageStates());
  }

  void changeIsLastToBeFalse() {
    isLast = false;
    emit(OnBoardingNotLastPageStates());
  }

  void submit(context) {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        emit(OnBoardingSubmittedState());
        navigateTo(context, LoginScreen());
      }
    });
  }

  List<OnBoardingItem> onBoardingItems = [
    OnBoardingItem(
        'assets/images/undraw_Status_update_re_dm9y.png',
        'Update your status',
        'You can share your status with your friends now'),
    OnBoardingItem(
        'assets/images/undraw_Social_life_re_x7t5.png',
        'React friends posts',
        'React with positive and negative posts and say your opinion'),
    OnBoardingItem('assets/images/undraw_trends_a5mf.png', '#Be_Trend',
        'Share your skills to make it trending'),
    OnBoardingItem('assets/images/undraw_Social_networking_re_i1ex.png',
        'Connect your friends', 'You will enjoy chatting with your friends'),
  ];
}
