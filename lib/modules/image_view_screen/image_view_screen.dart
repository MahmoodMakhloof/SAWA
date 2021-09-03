import 'package:flutter/material.dart';
import 'package:social/shared/components/constants.dart';

class ImageViewScreen extends StatefulWidget {
  final String? image;
  final String? body;

  const ImageViewScreen({Key? key, required this.image,required this.body}) : super(key: key);

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {

  bool showText = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: InkWell(
          onTap: ()
          {
            setState(() {
              showText =!showText;
            });
          },
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,

            children: [
              new Image.network(
                "${widget.image}",
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              if(showText ==true && widget.body !='')
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                ),
                  child: Center(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text('${widget.body}',style: TextStyle(fontSize: 15),textAlign: TextAlign.center,),
                  )))
            ],
          ),
        ),
      ),
    );
  }
}
