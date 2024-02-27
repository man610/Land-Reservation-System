import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:mahabhoomiweb/screens/home_page.dart';
// import 'package:mahabhoomiweb/constants/constants.dart';
import 'package:universal_html/html.dart' as html;
// import 'package:flutter_svg/flutter_svg.dart';
import '../constant/utils.dart';

class FooterWidget extends StatelessWidget {
  static final appContainer = kIsWeb
      ? html.window.document.querySelectorAll('flt-glass-pane')[0]
      : null;

  double scrHeight = 00.0;

  double scrWidth = 00.0;

  FooterWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    scrWidth = MediaQuery.of(context).size.width;
    scrHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/landimg.jpg'),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
          color: Color(0xFF112E51),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, left: 1),
                    child: SizedBox(
                      width: scrWidth / 3,
                      child: Flexible(
                        child: Text(
                          'About us',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: customColorScheme.background,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, left: 1),
                    child: SizedBox(
                      width: scrWidth / 3,
                      child: Flexible(
                        child: Text(
                          '    Mahabhoomi is a blockchain-based solution for land registration developed by students, aiming to provide a secure, transparent, and efficient platform for land transactions. ',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: customColorScheme.background,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, left: 1),
                    child: Text(
                      'Contact Us :',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: customColorScheme.background,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: InkWell(
                      child: const Text(
                        '1. Prof. Sheetal Nagar (Mentor)',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFFFFFFE7),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: const Text(
                      ' 2. Darshik BHuva',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFFFFFFE7),
                      ),
                    ),
                  ),
                  InkWell(
                    child: const Text(
                      ' 3. durvik katheriya',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFFFFFFE7),
                      ),
                    ),
                  ),
                  const Text(
                    ' 4. Patel Man',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFFFFFFE7),
                    ),
                  ),
                  const Text(
                    ' 5. Jay Boghra',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Color(0xFFF1F1EE),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '© 2023 Government of India',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.amberAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
