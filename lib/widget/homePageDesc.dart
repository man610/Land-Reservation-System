import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

import '../constant/utils.dart';

class LeftDescription extends StatefulWidget {
  const LeftDescription({Key? key}) : super(key: key);
  static final appContainer = kIsWeb
      ? html.window.document.querySelectorAll('flt-glass-pane')[0]
      : null;

  @override
  State<LeftDescription> createState() => _LeftDescriptionState();
}

class _LeftDescriptionState extends State<LeftDescription> {

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _componentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    double scrWidth=590;
    double scrHeight=590;
    scrWidth = MediaQuery.of(context).size.width;
    scrHeight = MediaQuery.of(context).size.height;
    if (kIsWeb){
      isDesktop = true;
    }

    if (scrWidth < 600) {
      isDesktop = false;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[


        // title
        const FittedBox(
          child:
          Padding(
          padding: EdgeInsets.all(30),
            child: Text(
              'MahaBhoomi',
              style: TextStyle(
                fontFamily: 'AutourOne',
                fontWeight: FontWeight.bold,
                fontSize: 35,
                // letterSpacing: 1.627907,
              ),
            ),


    )

        ),
        // Description

        // const SizedBox(
        //   height,
        // ),
        // const SizedBox(height: 26),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            // button
            InkWell(
              onTap: () {
                final context = _componentKey.currentContext;
                if (context != null) {
                  _scrollController.animateTo(
                    context.size?.height ?? 0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Container(
                  alignment: Alignment.center,
                  width: scrWidth*0.2,
                  height: 60,
                  child: const Center(
                    child: Text("Learn More",
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color:Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          letterSpacing: 2,
                        )),
                  ),
                  decoration: BoxDecoration(
                      color: customColorScheme.secondary,
                      borderRadius: BorderRadius.circular(scrWidth/20*0.2)
                  )
              ),
            ),
            //
            GestureDetector(
              onTap: () {
                launchUrl("https://github.com/Prajyot02/Mahabhoomi");
              },
              child: MouseRegion(
                onHover: (PointerHoverEvent evt) {
                  LeftDescription.appContainer?.style.cursor = 'pointer';
                },
                onExit: (PointerExitEvent evt) {
                  LeftDescription.appContainer?.style.cursor = 'default';
                },
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(" Terms and Conditions ",
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Montserrat',
                            color: customColorScheme.secondary,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 2,
                          )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(
        //   height: 100,
        // )
      ],
    );
  }
}
