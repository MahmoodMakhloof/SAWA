import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';
import 'package:social/shared/social_cubit/social_states.dart';
import 'package:social/shared/style/icon_broken.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({Key? key}) : super(key: key);

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  var postController = TextEditingController();
  String post = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is CreatePostSuccessState) {

        }
      },
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark),
            elevation: 0,
            backgroundColor: GREEN.withOpacity(0.4),
            backwardsCompatibility: false,
            leading: IconButton(
              icon: Icon(
                IconBroken.Arrow___Left_2,
                color: BROWN,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              if (cubit.postImage != null || post != '')
                TextButton(
                    onPressed: () {
                      print('post');
                      print(postController.text);

                      if (cubit.postImage != null) {
                        print('image existed');
                        cubit.uploadPostImage(
                            body: postController.text,
                            datetime: DateTime.now().toString());
                      } else {
                        print('post only existed');
                        cubit.uploadPost(
                            body: postController.text,
                            datetime: DateTime.now().toString());
                      }
                      showToast(
                          msg: 'Post Loading', state: ToastState.SUCCESS);
                      postController.text = '';
                      SocialCubit.get(context).removeImageOfThePost();
                      Navigator.pop(context);

                    },
                    child: Text(
                      'Post',
                      style: TextStyle(color: BROWN),
                    )),
            ],
            title: Text(
              'Add post',
              style: TextStyle(
                color: BROWN,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                if (state is PostImageUploadLoadingState)
                  LinearProgressIndicator(
                    color: GREEN,
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  child: Container(
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          post = value;
                        });
                      },
                      maxLines: null,
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      enableInteractiveSelection: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      enableSuggestions: true,
                      scrollPhysics: BouncingScrollPhysics(),
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        hintText: 'what are you thinking..',
                      ),
                      autocorrect: true,
                      controller: postController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'The post can\'t be empty';
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {},
                    ),
                  ),
                ),
                if (cubit.postImage != null)
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                              topLeft: Radius.circular(25),
                            ),
                          ),
                          width: double.infinity,
                          height: 320,
                          child: Image.file(
                            File(cubit.postImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: CircleAvatar(
                            backgroundColor: Colors.black.withOpacity(0.5),
                            radius: 17,
                            child: IconButton(
                                onPressed: () {
                                  cubit.removeImageOfThePost();
                                },
                                icon: Icon(
                                  IconBroken.Close_Square,
                                  color: Colors.white,
                                  size: 17,
                                ))),
                      )
                    ],
                  ),
                SizedBox(
                  height: 22,
                ),
              ],
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 15,
              onPressed: () {
                cubit.getPostImage();
              },
              child: Icon(
                IconBroken.Image,
                color: GREEN.withOpacity(1),
              ),
            ),
          ),
        );
      },
    );
  }
}
