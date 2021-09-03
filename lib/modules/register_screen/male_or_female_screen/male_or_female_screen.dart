import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social/modules/register_screen/register_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/style/icon_broken.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  _GenderScreenState createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  bool isMale = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.4),
        backwardsCompatibility: false,
        actions: [
          TextButton(
              onPressed: () {
                print('Done');
                navigateTo(
                    context,
                    RegisterScreen(
                      isMale: isMale,
                    ));
              },
              child: Text(
                'Done',
                style: TextStyle(color: GREEN, fontWeight: FontWeight.w600),
              )),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isMale = true;
                });
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/undraw_male_avatar_323b.png'),
                      ),
                    ),
                    width: 250,
                    height: 250,

                  ),
                  if (isMale == true)
                    Container(
                      decoration: BoxDecoration(
                        color: GREEN.withOpacity(0.25),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      height: 250,
                      width: 250,
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isMale = false;
                });
              },
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/undraw_female_avatar_w3jk.png'),
                      ),
                    ),
                    width: 250,
                    height: 250,
                  ),
                  if (isMale == false)
                    Container(
                      decoration: BoxDecoration(
                        color: GREEN.withOpacity(0.25),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      height: 250,
                      width: 250,
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
