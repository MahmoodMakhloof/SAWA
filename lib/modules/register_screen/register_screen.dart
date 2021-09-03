import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/social_layout_screen.dart';
import 'package:social/modules/login_screen/login_screen.dart';
import 'package:social/modules/register_screen/register_cubit/cubit.dart';
import 'package:social/modules/register_screen/register_cubit/states.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/network/local/cache_helper.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';

class RegisterScreen extends StatelessWidget {
  final bool isMale;
  RegisterScreen({Key? key, required this.isMale}) : super(key: key);

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameControl = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {
            if (state is RegisterErrorState) {
              showToast(msg: state.error, state: ToastState.ERROR);
            }

            if (state is UserCreateSuccessState) {
              CacheHelper.saveData(key: 'uid', value: state.model.uid);
              uid = state.model.uid;
              print(uid);
              navigateAndFinish(context, SocialLayoutScreen(afterLoginOrRegister: true,));
            }
          },
          builder: (context, state) {
            RegisterCubit cubit = RegisterCubit.get(context);

            return Scaffold(
              backgroundColor: Colors.white,
              body: Column(
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
                            Colors.green.withOpacity(0.7), BlendMode.dstOut),
                        image: AssetImage(
                          'assets/images/external-content.duckduckgo.com.jpg',
                        ),
                      ),
                    ),
                    width: double.infinity,
                    height: 250,
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              defaultTextField(
                                  onSubmit: (value) {
                                    print(value);
                                  },
                                  onTap: () {},
                                  textForUnValid: 'Enter your name',
                                  controller: nameControl,
                                  type: TextInputType.emailAddress,
                                  text: 'Name',
                                  prefix: Icons.person),
                              SizedBox(
                                height: 10,
                              ),
                              defaultTextField(
                                  onSubmit: (value) {
                                    print(value);
                                  },
                                  onTap: () {},
                                  textForUnValid: 'Enter your email',
                                  controller: emailController,
                                  type: TextInputType.emailAddress,
                                  text: 'email',
                                  prefix: Icons.email_outlined),
                              SizedBox(
                                height: 10,
                              ),
                              defaultTextField(
                                  onSubmit: (value) {
                                    if (formKey.currentState!.validate() ==
                                        true) {
                                      // cubit.userRegister(
                                      //     phone: phoneControl.text,
                                      //     name: nameControl.text,
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
                              SizedBox(
                                height: 3,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Don you have an account',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          navigateTo(context, LoginScreen());
                                        },
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: GREEN),
                                        ),
                                      ),
                                    ],
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  state is! RegisterLoadingState
                      ? InkWell(
                          onTap: () {
                            print('button taped');
                            if (formKey.currentState!.validate() == true) {
                              cubit.userRegister(
                                  name: nameControl.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  isMale: isMale);
                            } else {
                              print('else button');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                gradient:
                                    LinearGradient(colors: [GREEN, YELLOW])),
                            width: double.infinity,
                            height: 47,
                            child: Center(
                                child: Text(
                              'SIGN UP',
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
            );
          },
        );
  }
}
