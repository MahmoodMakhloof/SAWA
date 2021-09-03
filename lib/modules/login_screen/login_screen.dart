import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/social_layout_screen.dart';
import 'package:social/modules/login_screen/login_cubit/cubit.dart';
import 'package:social/modules/register_screen/male_or_female_screen/male_or_female_screen.dart';
import 'package:social/modules/register_screen/register_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/network/local/cache_helper.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';

import 'login_cubit/states.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  var disKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is LoginErrorState) {
              showToast(msg: state.error, state: ToastState.ERROR);
            }

            if (state is LoginSuccessState) {
              CacheHelper.saveData(key: 'uid', value: state.uid);
              uid = state.uid;
              print(uid);
              navigateAndFinish(context, SocialLayoutScreen(afterLoginOrRegister: true,));
            }
          },
          builder: (context, state) {
            LoginCubit cubit = LoginCubit.get(context);
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark));
            return Scaffold(
                backgroundColor: Colors.white,
                body: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //   begin: Alignment.topRight,
                          //   end: Alignment.bottomLeft,
                          //   colors: [
                          //     RED,
                          //     BROWN,
                          //   ],
                          // ),
                          color: Colors.white),
                      width: double.infinity,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [GREEN, YELLOW],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  GREEN.withOpacity(0.7), BlendMode.dstOut),
                              image: AssetImage(
                                'assets/images/external-content.duckduckgo.com.jpg',
                              ),
                            ),
                          ),
                          width: double.infinity,
                          height: 250,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Form(
                              key: formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      // gradient: LinearGradient(
                                      //   begin: Alignment.topRight,
                                      //   end: Alignment.bottomLeft,
                                      //   colors: [
                                      //     Colors.white,
                                      //     RED,
                                      //   ],
                                      // ),
                                      borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                  )),
                                  child: Column(
                                    children: [
                                      defaultTextField(
                                          onSubmit: (value) {
                                            print(value);
                                          },
                                          onTap: () {},
                                          textForUnValid: 'Enter your username',
                                          controller: emailController,
                                          type: TextInputType.emailAddress,
                                          text: 'Username',
                                          prefix: Icons.alternate_email),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      defaultTextField(
                                          onSubmit: (value) {
                                            if (formKey.currentState!
                                                    .validate() ==
                                                true) {
                                              // cubit.userLogin(
                                              //     email: emailController.text,
                                              //     password: passwordController.text);
                                            }
                                          },
                                          onTap: () {},
                                          textForUnValid: 'Enter you password',
                                          controller: passwordController,
                                          type: TextInputType.visiblePassword,
                                          text: 'Password',
                                          prefix: Icons.lock,
                                          isPassword: cubit.isPassword,
                                          suffix: cubit.isPassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          suffixFunction: () {
                                            cubit.changePasswordShow();
                                          }),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Don\'t have an account',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              navigateTo(
                                                  context, GenderScreen());
                                            },
                                            child: Text(
                                              'Register now',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: GREEN),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Container(
                                            color: BROWN,
                                            height: 0.3,
                                          )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'OR',
                                            style: TextStyle(
                                                color: BROWN,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Container(
                                            color: BROWN,
                                            height: 0.3,
                                          )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              print('google login');
                                            },
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                  'assets/images/icons8-google-48.png'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print('twitter login');
                                            },
                                            child: CircleAvatar(
                                              radius: 17,
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                  'assets/images/icons8-twitter-48.png'),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              print('facebook login');
                                            },
                                            child: CircleAvatar(
                                              radius: 16,
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                  'assets/images/icons8-facebook-logo-48.png'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        state is! LoginLoadingState
                            ? InkWell(
                                onTap: () {
                                  print('button taped');
                                  if (formKey.currentState!.validate() ==
                                      true) {
                                    cubit.userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  } else {
                                    print('else button');
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [GREEN, YELLOW])),
                                  width: double.infinity,
                                  height: 47,
                                  child: Center(
                                      child: Text(
                                    'LOGIN',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: BROWN),
                                  )),
                                ),
                              )
                            : Center(
                                child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: CircularProgressIndicator(
                                  color: BROWN,
                                ),
                              )),
                      ],
                    ),
                  ],
                ));
          },
        );
  }
}
