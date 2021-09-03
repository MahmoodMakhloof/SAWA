import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social/models/on_boarding.dart';
import 'package:social/shared/components/constants.dart';
import 'on_boarding_cubit/on_boarding_cubit.dart';
import 'on_boarding_cubit/on_boarding_states.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => OnBoardingCubit(),
      child: BlocConsumer<OnBoardingCubit, OnBoardingStates>(
          listener: (context, state) {},
          builder: (context, state) {
            OnBoardingCubit cubit = OnBoardingCubit.get(context);

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark),
                actions: [
                  TextButton(
                    onPressed: () {
                      cubit.submit(context);
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                          color: GREEN,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
              body: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                YELLOW,
                                GREEN,
                              ],
                            ),
                          ),
                          width: double.infinity,
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            ),
                            color: Colors.white),
                        height: 350,
                        width: double.infinity,
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: PageView.builder(
                          onPageChanged: (index) {
                            if (index == cubit.onBoardingItems.length - 1) {
                              cubit.changeIsLastToBeTrue();
                            } else {
                              cubit.changeIsLastToBeFalse();
                            }
                          },
                          physics: BouncingScrollPhysics(),
                          controller: pageController,
                          itemBuilder: (context, index) =>
                              itemBuilder(cubit.onBoardingItems[index]),
                          itemCount: cubit.onBoardingItems.length,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            SmoothPageIndicator(
                              controller: pageController,
                              count: cubit.onBoardingItems.length,
                              effect: ExpandingDotsEffect(
                                activeDotColor: YELLOW,
                                dotHeight: 10,
                                dotWidth: 10,
                              ),
                            ),
                            Spacer(),
                            FloatingActionButton(
                              onPressed: () {
                                if (cubit.isLast == true) {
                                  cubit.submit(context);
                                } else {
                                  pageController.nextPage(
                                      duration: Duration(microseconds: 750),
                                      curve: Curves.bounceIn);
                                }
                              },
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: YELLOW,
                              ),
                              backgroundColor: GREEN,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget itemBuilder(OnBoardingItem item) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Image(
            image: AssetImage(item.image),
            fit: BoxFit.fill,
            height: 240,
            width: 300,
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    color: BROWN,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  item.body,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                    color: BROWN,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
