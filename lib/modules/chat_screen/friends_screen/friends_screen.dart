import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/modules/chat_screen/person_chat_screen/person_chat_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';
import 'package:social/shared/social_cubit/social_states.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);

        return cubit.users.length >= 0
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              // cubit.messages = [];
                              navigateTo(
                                  context,
                                  PersonChatScreen(
                                    cubit.users[index],
                                  ));
                            },
                            child: singleFollowerBuilder(cubit.users[index],context)),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                        itemCount: cubit.users.length),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                color: GREEN,
              ));
      },
    );
  }
}
