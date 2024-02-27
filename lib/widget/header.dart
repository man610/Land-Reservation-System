import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:mahabhoomiweb/screens/home_page.dart';
// import 'package:mahabhoomiweb/constants/constants.dart';
import 'package:universal_html/html.dart' as html;
// import 'package:flutter_svg/flutter_svg.dart';
import '../constant/utils.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  static final appContainer = kIsWeb
      ? html.window.document.querySelectorAll('flt-glass-pane')[0]
      : null;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    if (width > 600) {
      // width = 590;
      isDesktop = true;
    }
    if (width < 600) {
      // width = 460;
      isDesktop = false;
    }

    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue, Colors.white]),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0.0, 6.0),
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5.0,
            ),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // logo
          Padding(
            padding: const EdgeInsets.only(left: 2.0),
            child: Image.asset(
              'assets/logo.png',
              height: 100,
              width: 100,
              fit: BoxFit.fill,
            ),
          ),

          const Text(
            'MahaBhoomi',
            style: TextStyle(
              fontFamily: 'AutourOne',
              fontWeight: FontWeight.bold,
              fontSize: 25,
              // letterSpacing: 1.627907,
            ),
          ),
          // const SizedBox(
          //   width: width/10, //<-- SEE HERE
          // ),
          SingleChildScrollView(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const CheckPrivateKey(
                    //               val: "UserLogin",
                    //             )));
                    Navigator.of(context).pushNamed(
                      '/',
                      arguments: "Home",
                    );
                  },
                  child: MouseRegion(
                    onHover: (PointerHoverEvent evt) {
                      appContainer?.style.cursor = 'pointer';
                    },
                    onExit: (PointerExitEvent evt) {
                      appContainer?.style.cursor = 'default';
                    },
                    child: const Text(
                      'Home',
                      style: TextStyle(
                        fontFamily: 'Lato-bold',
                        color: Color(0xff28313b),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.627907,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const CheckPrivateKey(
                    //               val: "UserLogin",
                    //             )));
                    Navigator.of(context).pushNamed(
                      '/login',
                      arguments: "UserLogin",
                    );
                  },
                  child: MouseRegion(
                    onHover: (PointerHoverEvent evt) {
                      appContainer?.style.cursor = 'pointer';
                    },
                    onExit: (PointerExitEvent evt) {
                      appContainer?.style.cursor = 'default';
                    },
                    child: const Text(
                      'User Login',
                      style: TextStyle(
                        fontFamily: 'Lato-bold',
                        color: Color(0xff28313b),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.627907,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const CheckPrivateKey(
                    //               val: "LandInspector",
                    //             )));
                    Navigator.of(context).pushNamed(
                      '/login',
                      arguments: "LandInspector",
                    );
                  },
                  child: MouseRegion(
                    onHover: (PointerHoverEvent evt) {
                      appContainer?.style.cursor = 'pointer';
                    },
                    onExit: (PointerExitEvent evt) {
                      appContainer?.style.cursor = 'default';
                    },
                    child: const Text(
                      'Officials login',
                      style: TextStyle(
                        fontFamily: 'Lato-bold',
                        color: Color(0xff28313b),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.627907,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const CheckPrivateKey(
                    //               val: "owner",
                    //             )));
                    Navigator.of(context).pushNamed(
                      '/login',
                      arguments: "owner",
                    );
                  },
                  child: MouseRegion(
                    onHover: (PointerHoverEvent evt) {
                      appContainer?.style.cursor = 'pointer';
                    },
                    onExit: (PointerExitEvent evt) {
                      appContainer?.style.cursor = 'default';
                    },
                    child: const Text(
                      'Govt login',
                      style: TextStyle(
                        fontFamily: 'Lato-black',
                        color: Color(0xff28313b),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.627907,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: GestureDetector(
                  onTap: () async {
                    // await Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => RegisterUser()));
                    Navigator.of(context).pushNamed(
                      '/about',
                      arguments: "about",
                    );
                  },
                  child: MouseRegion(
                    onHover: (PointerHoverEvent evt) {
                      appContainer?.style.cursor = 'pointer';
                    },
                    onExit: (PointerExitEvent evt) {
                      appContainer?.style.cursor = 'default';
                    },
                    child: const Text(
                      'About',
                      style: TextStyle(
                        color: Color(0xff28313b),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 1.627907,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Image.asset(
                  'gom-removebg.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain, // Adjust this as needed
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
