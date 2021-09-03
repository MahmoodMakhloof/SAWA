import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/social_cubit/social_cubit.dart';
import 'package:social/shared/social_cubit/social_states.dart';
import 'package:social/shared/style/icon_broken.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return Scaffold(
            key: scaffoldKey,
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
                if (cubit.profileImage != null ||
                    cubit.coverImage != null ||
                    cubit.newBio != '')
                  TextButton(
                      onPressed: () async {

                          if (cubit.profileImage != null ||
                              cubit.coverImage != null ||
                              cubit.newBio != '') {
                            if (cubit.profileImage != null) {
                              await cubit.uploadProfileImage();
                            }
                            if (cubit.coverImage != null) {
                              await cubit.uploadCoverImage();
                            }

                            await cubit.updateBio();
                          }

                          cubit.coverImage = null;
                          cubit.profileImage = null;
                          cubit.newBio = '';
                          Navigator.pop(context);



                      },
                      child: Text(
                        'Update',
                        style: TextStyle(color: BROWN),
                      )),
              ],
              title: Text(
                'Edit Profile',
                style: TextStyle(
                  color: BROWN,
                ),
              ),
            ),
            body: cubit.model != null
                ? SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    'Edit cover image',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black54),
                                  )),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  cubit.getCoverImage();
                                },
                                icon: Icon(
                                  IconBroken.Edit,
                                  color: GREEN,
                                ))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue, GREEN],
                              ),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                                topLeft: Radius.circular(25),
                              ),
                            ),
                            width: double.infinity,
                            height: 235,
                            child: cubit.coverImage == null
                                ? Image(
                                    image: NetworkImage(
                                        '${cubit.model!.coverImage}'),
                                    fit: BoxFit.cover,
                                    height: 235,
                                    width: double.infinity,
                                  )
                                : Image.file(
                                    File(cubit.coverImage!.path),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    'Edit profile image',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black54),
                                  )),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  cubit.getProfileImage();
                                },
                                icon: Icon(
                                  IconBroken.Edit,
                                  color: GREEN,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        CircleAvatar(
                          radius: 64,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                              radius: 60,
                              child: ClipOval(
                                child: cubit.profileImage == null
                                    ? Image(
                                        image: NetworkImage(
                                          '${cubit.model!.profileImage}',
                                        ),
                                        fit: BoxFit.cover,
                                        height: 120,
                                        width: 120,
                                      )
                                    : Image.file(
                                        File(cubit.profileImage!.path),
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                clipBehavior: Clip.hardEdge,
                              )),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    'Edit bio',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black54),
                                  )),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  bioController.text =
                                      '${cubit.newBio == '' ? cubit.model!.bio : cubit.newBio}';
                                  scaffoldKey.currentState!
                                      .showBottomSheet((context) => Form(
                                            key: formKey,
                                            child: Container(
                                              height: 90,
                                              decoration: BoxDecoration(
                                                  color: GREEN.withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.only()),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: TextFormField(
                                                  maxLines: null,
                                                  autofocus: true,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  enableInteractiveSelection:
                                                      true,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                  enableSuggestions: true,
                                                  scrollPhysics:
                                                      BouncingScrollPhysics(),
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    border: InputBorder.none,
                                                    hintText: 'Edit your bio',
                                                  ),
                                                  autocorrect: true,
                                                  controller: bioController,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'The bio can\'t be empty';
                                                    }
                                                    return null;
                                                  },
                                                  onFieldSubmitted: (value) {
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      cubit.newBio =
                                                          bioController.text;
                                                      bioController.text = '';
                                                      setState(() {});
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ));
                                },
                                icon: Icon(
                                  IconBroken.Edit,
                                  color: GREEN,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: GREEN.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 15, left: 15, top: 10, bottom: 10),
                              child: Text(
                                '${cubit.newBio == '' ? cubit.model!.bio : cubit.newBio}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: BROWN,
                                    fontSize: 13),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                    color: GREEN,
                  )));
      },
    );
  }
}
