import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/services.dart';

import '../../constant/utils.dart';
import '../../providers/LandRegisterModel.dart';
import '../../providers/MetaMaskProvider.dart';
import '../../widget/header.dart';
import '../addLandInspector.dart';
import '../land_inspector_dashboard.dart';
import '../registerUser.dart';
import '../user_dashboard.dart';


class my_login_page extends StatefulWidget {
  final String val;
  const my_login_page({Key? key, required this.val}) : super(key: key);

  @override
  _my_login_pageState createState() => _my_login_pageState();
}

class _my_login_pageState extends State<my_login_page> {
  String code = randomAlpha(5);
  String privatekey = "";
  String errorMessage = "I am error";
  bool isDesktop = false;
  double width = 590;
  bool _isObscure = true;
  bool isLoading = false;
  double scrWidth = 0.0;
  double scrHeight = 0.0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController keyController = TextEditingController();
  TextEditingController UIDcontroller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var model = Provider.of<LandRegisterModel>(context);
    var model2 = Provider.of<MetaMaskProvider>(context);
    scrWidth = MediaQuery.of(context).size.width;
    scrHeight = MediaQuery.of(context).size.height;

    // final sw = MediaQuery.of(context).size.width;
    width = MediaQuery.of(context).size.width;
    // if (width > 600) {
    //   width = 590;
    //   isDesktop = true;
    // }
    // if (width < 600) {
    //   width = 460;
    //   isDesktop = false;
    // }

    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Stack(
            children: [
              const Material(
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: HeaderWidget(),
                ),
              ),

              SizedBox(
                // decoration: BoxDecoration(color: Colors.amberAccent),
                width: scrWidth,
                height: scrHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: scrHeight/3,
                      child:
                      Image.asset(
                        'assets/logo_gom_image.png',
                        fit: BoxFit.fill,
                        //color: Color.fromARGB(255, 255, 169, 98),
                        // height: 20.0,
                        // width: 20.0,
                        // allowDrawingOutsideViewBox: true,
                      ),
                    ),
                    Container(
                      height:scrHeight/3,
                      width: 1.0,
                      color: Colors.black,
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    ),
                    SizedBox(
                        width: scrWidth * 0.45,
                        height: scrWidth * 0.45,
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'UID :',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                                width:400,
                                child:Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child:  Form(
                                    child: TextFormField(
                                      controller: UIDcontroller,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter uid';
                                        }
                                        return null;
                                      },
                                      // obscureText: _isObscure,
                                      onChanged: (val) {
                                        privatekey = val;
                                      },
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'Enter Your UID',
                                      ),
                                    ),
                                  ),
                                )
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Private Key :',
                              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,),
                            ),
                            SizedBox(
                              width: 400,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: keyController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter private key';
                                      }
                                      return null;
                                    },
                                    obscureText: _isObscure,
                                    onChanged: (val) {
                                      privatekey = val;
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon: MaterialButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () async {
                                          final clipPaste =
                                          await Clipboard.getData(Clipboard.kTextPlain);
                                          keyController.text = clipPaste!.text!;
                                          privatekey = keyController.text;
                                          setState(() {});
                                        },
                                        child: const Text(
                                          "Paste",
                                          style: TextStyle(
                                              color: Colors.blue
                                          ),
                                        ),
                                      ),
                                      suffix: IconButton(
                                          iconSize: 20,
                                          constraints: const BoxConstraints.tightFor(
                                              height: 15, width: 15),
                                          padding: const EdgeInsets.all(0),
                                          icon: Icon(
                                            _isObscure
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isObscure = !_isObscure;
                                            });}
                                      ),
                                      border: const OutlineInputBorder(),
                                      labelText: 'Private Key',
                                      hintText: 'Enter Your Private Key',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),

                            SizedBox(
                              width: scrWidth/5,
                              height: 10,
                              child:(
                                  Image.asset('assets/captcha_sample.png',
                                    width: scrWidth * 0.5,
                                    height: scrHeight,
                                    fit: BoxFit.scaleDown,
                                    color: const Color.fromRGBO(255, 255, 255, 0.4),
                                    colorBlendMode: BlendMode.modulate,
                                    alignment: Alignment.bottomLeft,
                                  )
                              ),
                            ),
                            CustomButton(
                                'Continue',
                                isLoading
                                    ? null
                                    : () async {
                                  if (_formKey.currentState!.validate()) {
                                    privateKey = privatekey;
                                    //print(privateKey);
                                    connectedWithMetamask = false;
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      await model.initiateSetup();

                                      if (widget.val == "owner") {
                                        bool temp =
                                        await model.isContractOwner(privatekey);
                                        if (temp == false) {
                                          setState(() {
                                            errorMessage = "You are not authrosied";
                                          });
                                        } else {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AddLandInspector()));
                                          // Navigator.of(context).pushNamed(
                                          //   '/contractowner',
                                          // );
                                        }
                                      } else if (widget.val == "RegisterUser") {
                                        bool temp = await model.isUserregistered();
                                        if (temp) {
                                          setState(() {
                                            errorMessage = "You already registered";
                                          });
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                  const RegisterUser()));
                                        }
                                      } else if (widget.val == "LandInspector") {
                                        bool temp =
                                        await model.isLandInspector(privatekey);
                                        if (temp == false) {
                                          setState(() {
                                            errorMessage = "You are not authrosied";
                                          });
                                        } else {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                  const LandInspector())
                                          );
                                          // Navigator.of(context).pushNamed(
                                          //   '/landinspector',
                                          // );
                                        }
                                      } else if (widget.val == "UserLogin") {
                                        bool temp = await model.isUserregistered();
                                        if (temp == false) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                  const RegisterUser())
                                          );
                                          // Navigator.of(context).pushNamed(
                                          //   '/registeruser',
                                          // );
                                        } else {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                  const UserDashBoard())
                                          );
                                          // Navigator.of(context).pushNamed(
                                          //   '/user',
                                          // );
                                        }
                                      }
                                    } catch (e) {
                                      print(e);
                                      showToast("Something Went Wrong",
                                          context: context, backgroundColor: Colors.red);
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                  alignment: Alignment.center,
                                  width: scrWidth*0.12,
                                  height: 40,
                                  child: const Center(
                                    child: Text("Sign In ",
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xffffffff),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: 2,
                                        )),
                                  ),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 255, 98, 0),
                                      borderRadius: BorderRadius.circular(10))
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child:
                              SizedBox(
                                height: 80,
                                width: 300,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await model2.connect();
                                    if (model2.isConnected && model2.isInOperatingChain) {
                                      showToast("Connected",
                                          context: context, backgroundColor: Colors.green);

                                      if (widget.val == "owner") {
                                        bool temp = await model2.isContractOwner();
                                        if (temp == false) {
                                          setState(() {
                                            errorMessage = "You are not authrosied";
                                          });
                                        } else {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => const AddLandInspector()));
                                          Navigator.of(context).pushNamed(
                                            '/contractowner',
                                          );
                                        }
                                      } else if (widget.val == "UserLogin") {
                                        bool temp = await model2.isUserRegistered();
                                        if (temp == false) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => const RegisterUser()));
                                          Navigator.of(context).pushNamed(
                                            '/registeruser',
                                          );
                                        } else {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => const UserDashBoard()));
                                          Navigator.of(context).pushNamed(
                                            '/user',
                                          );
                                        }
                                      } else if (widget.val == "LandInspector") {

                                        bool temp = await model2.isLandInspector();
                                        if (temp == false) {
                                          setState(() {
                                            errorMessage = "You are not authrosied";
                                          });
                                        } else {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => const LandInspector()));
                                          Navigator.of(context).pushNamed(
                                            '/landinspector',
                                          );
                                        }
                                      }
                                      connectedWithMetamask = true;
                                    }
                                    if (model2.isConnected && !model2.isInOperatingChain) {
                                      showToast("Wrong Netword connected,\nConnect Ropsten Testnet",
                                          context: context, backgroundColor: Colors.red);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                  child: Image.network(
                                      'https://i0.wp.com/kindalame.com/wp-content/uploads/2021/05/metamask-fox-wordmark-horizontal.png?fit=1549%2C480&ssl=1',
                                      width: 280,
                                      height: 80),
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(0),
                  child:(
                      Image.asset('assets/background_image.png',
                        width: scrWidth * 0.3,
                        height: scrHeight,
                        fit: BoxFit.scaleDown,
                        color: const Color.fromRGBO(255, 255, 255, 0.4),
                        colorBlendMode: BlendMode.modulate,
                        alignment: Alignment.bottomLeft,
                      )
                  )
              ),
            ],
          ),
          // Top Header
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}

