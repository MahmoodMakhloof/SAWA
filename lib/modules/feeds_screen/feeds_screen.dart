import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social/layout/social_layout_screen.dart';
import 'package:social/models/post_model.dart';
import 'package:social/modules/new_post_screen/new_post_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';
import 'package:social/shared/social_cubit/social_states.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  var refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SocialCubit cubit = SocialCubit.get(context);

          return Conditional.single(
            context: context,
            conditionBuilder: (BuildContext context) =>
                cubit.posts.length >= 0 == true,
            widgetBuilder: (BuildContext context) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      Card(
                        elevation: 10,
                        margin: EdgeInsets.all(5),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Image(
                            image: NetworkImage(
                                'https://i.pinimg.com/564x/89/4f/2c/894f2ca5d588724fd8df8173a922874c.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Text(
                          'Always be connected\nwith your friends',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.9),
                              backgroundColor: Colors.white.withOpacity(0.01)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.all(5),
                    elevation: 5,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 23,
                                backgroundImage: NetworkImage(
                                  '${cubit.model!.profileImage}',
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    navigateTo(context, NewPostScreen());
                                  },
                                  child: Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: GREEN,width: 1.1)
                                    ),
                                    child: Center(
                                      child: Text(
                                        'What are you thinking..',
                                        style: TextStyle(color: Colors.black54,fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   child: Column(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Text(
                              //         '${cubit.model!.name}',
                              //         textAlign: TextAlign.start,
                              //         maxLines: 1,
                              //         overflow: TextOverflow.ellipsis,
                              //         style: TextStyle(
                              //             fontSize: 17,
                              //             color: BROWN,
                              //             fontWeight: FontWeight.w600),
                              //       ),
                              //       Text(
                              //         'Public',
                              //         maxLines: 1,
                              //         overflow: TextOverflow.ellipsis,
                              //         style: TextStyle(
                              //             fontSize: 9,
                              //             color: GREEN,
                              //             fontWeight: FontWeight.w500),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     navigateTo(context, NewPostScreen());
                        //   },
                        //   child: Container(
                        //     width: double.infinity,
                        //     height: 70,
                        //     child: Padding(
                        //       padding: const EdgeInsets.only(left: 10, top: 5),
                        //       child: Text(
                        //         'What are you thinking..',
                        //         style: TextStyle(color: Colors.grey),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) =>
                          singlePostBuilder(cubit.posts[index], context, index),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                      itemCount: cubit.posts.length),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            fallbackBuilder: (BuildContext context) => Center(
                child: CircularProgressIndicator(
              color: GREEN,
            )),
          );
        });
  }
}
