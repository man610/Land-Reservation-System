import 'package:flutter/material.dart';
import 'package:land_registration/widget/footer.dart';
import 'package:land_registration/widget/header_user.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double scrWidth = 0.0;
    double scrHeight = 0.0;
    return Scaffold(
      
      body: Column(
        children: [
          Positioned(
          height: scrHeight * 0.10,
          width: scrWidth,
          child: const Material(
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: HeaderUserWidget(),
            ),
          ),
        ),
          // Center(
          //   child: Text('About page'),
          // ),
          Center(child: FooterWidget()),
        ],
      ),
    );
  }
}
