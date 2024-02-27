import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:land_registration/providers/LandRegisterModel.dart';
import 'package:land_registration/screens/transferOwnership.dart';
import 'package:land_registration/widget/menu_item_tile.dart';
import 'package:provider/provider.dart';
import '../constant/utils.dart';
import '../providers/MetamaskProvider.dart';
import '../widget/header_user.dart';

class LandInspector extends StatefulWidget {
  const LandInspector({Key? key}) : super(key: key);

  @override
  _LandInspectorState createState() => _LandInspectorState();
}

class _LandInspectorState extends State<LandInspector> {
  var model, model2;
  double scrWidth = 0.0;
  double scrHeight = 0.0;
  final colors = <Color>[Colors.indigo, Colors.blue, Colors.orange, Colors.red];
  List<List<dynamic>> userData = [];
  List<List<dynamic>> landData = [];
  List<List<dynamic>> paymenList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int screen = 0;
  bool isFirstTimeLoad = true;
  dynamic userCount = -1, landCount = -1;
  bool isLoading = false;

  List<Menu> menuItems = [
    Menu(title: 'Dashboard', icon: Icons.dashboard),
    Menu(title: 'Verify User', icon: Icons.verified_user),
    Menu(title: 'Verify Land', icon: Icons.web),
    Menu(title: 'Transfer Ownership', icon: Icons.transform),
    Menu(title: 'Logout', icon: Icons.logout),
  ];

  getUserCount() async {
    if (connectedWithMetamask) {
      userCount = await model2.userCount();
      landCount = await model2.landCount();
    } else {
      userCount = await model.userCount();
      landCount = await model.landCount();
    }
    isFirstTimeLoad = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    scrWidth = MediaQuery.of(context).size.width;
    scrHeight = MediaQuery.of(context).size.height;

    model = Provider.of<LandRegisterModel>(context);
    model2 = Provider.of<MetaMaskProvider>(context);
    if (isFirstTimeLoad) {
      getUserCount();
    }
    if (kIsWeb){
      isDesktop = true;
    }

    if (scrWidth < 600) {
      isDesktop = false;
    }
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
            width: scrWidth,
            top: scrHeight*0.10,
            height: scrHeight*0.90,
            child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  toolbarHeight: 0,
                  centerTitle: false,
                  // title: isDesktop ? null : Text('My App Title'),
                  backgroundColor: const Color(0xFF272D34),
                  leading: !isDesktop
                      ? Container()
                      : GestureDetector(
                           child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ), //AnimatedIcon(icon: AnimatedIcons.menu_arrow,progress: _animationController,),
                    ),
                    onTap: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                ),
                drawer: drawer2(),
                drawerScrimColor: Colors.transparent,
                body: Row(
                  children: [
                    isDesktop ? drawer2() : Container(),
                    if (screen == -1) const Center(child: CircularProgressIndicator()),
                    if (screen == 0)
                      Expanded(
                          child: ListView(
                            children: [
                              Row(
                                children: [
                                  _container(0),
                                  _container(1),
                                  _container(2),
                                ],
                              ),
                            ],
                          ))
                    else if (screen == 1)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          child: userList(),
                        ),
                      )
                    else if (screen == 2)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            child: landList(),
                          ),
                        )
                      else if (screen == 3)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(25),
                              child: transferOwnershipWidget(),
                            ),
                          )
                  ],
                ),
        )
        ),
        Positioned(
          height: scrHeight*0.10,
          width: scrWidth,
          child:const Material(
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: HeaderUserWidget(),
            ),
          ),
        ),
        Positioned(
          left: 0,
          width: scrWidth*0.2,
          bottom: 0,
          child: Padding(
              padding: const EdgeInsets.all(0),
              child:(
                  Image.asset('assets/background_image.png',
                    width: scrWidth * 0.3,
                    fit: BoxFit.scaleDown,
                    color: const Color.fromRGBO(255, 255, 255, 0.4),
                    colorBlendMode: BlendMode.modulate,
                    alignment: Alignment.bottomLeft,
                  )
              )
          ),
        )
      ],
    );
  }

  getLandList() async {
    setState(() {
      landData = [];
      isLoading = true;
    });
    List<dynamic> landList;
    if (connectedWithMetamask) {
      landList = await model2.allLandList();
    } else {
      landList = await model.allLandList();
    }

    List<dynamic> temp;
    for (int i = 0; i < landList.length; i++) {
      if (connectedWithMetamask) {
        temp = await model2.landInfo(landList[i]);
      } else {
        temp = await model.landInfo(landList[i]);
      }
      landData.add(temp);
      isLoading = false;
      setState(() {});
    }

    // screen = 2;
    setState(() {});
  }

  Widget landList() {
    return ListView.builder(
      itemCount: landData == null ? 1 : landData.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return const Column(
            children: [
              Divider(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '#',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                      child: Center(
                        child: Text('Owner Address',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 5),
                  Expanded(
                    child: Center(
                      child: Text('Area',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Price',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('PID',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('SurveyNo.',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Document',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Verify',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  )
                ],
              ),
              Divider(
                height: 15,
              )
            ],
          );
        }
        index -= 1;
        List<dynamic> data = landData[index];
        return Container(
          height: 60,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text((index + 1).toString()),
                flex: 1,
              ),
              Expanded(
                  child: Center(
                    child: Text(data[9].toString()),
                  ),
                  flex: 5),
              Expanded(
                  child: Center(
                    child: Text(
                      data[2].toString(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  flex: 3),
              Expanded(child: Center(child: Text(data[3].toString())), flex: 2),
              Expanded(child: Center(child: Text(data[5].toString())), flex: 2),
              Expanded(child: Center(child: Text(data[6].toString())), flex: 2),
              Expanded(
                  child: Center(
                      child: TextButton(
                    onPressed: () {
                      launchUrl(data[7].toString());
                    },
                    child: const Text(
                      'View Document',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )),
                  flex: 2),
              Expanded(
                  child: Center(
                    child: data[10]
                        ? const Text('Verified')
                        : ElevatedButton(
                            onPressed: () async {
                              SmartDialog.showLoading();
                              try {
                                if (connectedWithMetamask) {
                                  await model2.verifyLand(data[0]);
                                } else {
                                  await model.verifyLand(data[0]);
                                }
                                await getLandList();
                              } catch (e) {
                                print(e);
                              }
                              SmartDialog.dismiss();
                            },
                            child: const Text('Verify')),
                  ),
                  flex: 2),
            ],
          ),
        );
      },
    );
  }

  Future<void> getUserList() async {
    setState(() {
      userData = [];
      isLoading = true;
    });

    List<dynamic> userList;
    if (connectedWithMetamask) {
      userList = await model2.allUsers();
    } else {
      userList = await model.allUsers();
    }

    List<dynamic> temp;
    for (int i = 0; i < userList.length; i++) {
      if (connectedWithMetamask) {
        temp = await model2.userInfo(userList[i].toString());
      } else {
        temp = await model.userInfo(userList[i].toString());
      }
      userData.add(temp);
      isLoading = false;
      setState(() {});
    }
    setState(() {
      // screen = 1;
      isLoading = false;
    });
  }

  Widget userList() {
    return ListView.builder(
        itemCount: userData == null ? 1 : userData.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Column(
              children: [
                Divider(
                  height: 15,
                  thickness: 2,
                  color: Colors.black,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '#',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                        child: Center(
                          child: Text('Address',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        flex: 5),
                    Expanded(
                      child: Center(
                        child: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Center(
                        child: Text('Aadhar',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text('Pan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text('Document',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text('Verify',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    )
                  ],
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                  color: Colors.black,
                )
              ],
            );
          }
          index -= 1;
          List<dynamic> data = userData[index];
          return Container(
            height: 60,
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
            child: Row(
              children: [
                Expanded(
                  child: Text((index + 1).toString()),
                  flex: 1,
                ),
                Expanded(
                    child: Center(
                      child: Text(data[0].toString()),
                    ),
                    flex: 5),
                Expanded(
                    child: Center(
                      child: Text(data[1].toString()),
                    ),
                    flex: 3),
                Expanded(
                    child: Center(child: Text(data[4].toString())), flex: 2),
                Expanded(
                    child: Center(child: Text(data[5].toString())), flex: 2),
                Expanded(
                    child: Center(
                        child: TextButton(
                      onPressed: () {
                        launchUrl(data[6].toString());
                      },
                      child: const Text(
                        'View Document',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )),
                    flex: 2),
                Expanded(
                    child: Center(
                      child: data[8]
                          ? const Text('Verified')
                          : ElevatedButton(
                              onPressed: () async {
                                SmartDialog.showLoading();
                                try {
                                  if (connectedWithMetamask) {
                                    await model2.verifyUser(data[0].toString());
                                  } else {
                                    await model.verifyUser(data[0].toString());
                                  }
                                  await getUserList();
                                } catch (e) {
                                  print(e);
                                }
                                SmartDialog.dismiss();
                              },
                              child: const Text('Verify')),
                    ),
                    flex: 2),
              ],
            ),
          );
        });
  }

  Future<void> paymentDoneList() async {
    //SmartDialog.showLoading();
    try {
      setState(() {
        isLoading = true;
        paymenList = [];
      });
      List<dynamic> list;
      if (connectedWithMetamask) {
        list = await model2.paymentDoneList();
      } else {
        list = await model.paymentDoneList();
      }

      List<dynamic> temp;
      for (int i = 0; i < list.length; i++) {
        if (connectedWithMetamask) {
          temp = await model2.requestInfo(list[i]);
        } else {
          temp = await model.requestInfo(list[i]);
        }
        paymenList.add(temp);
        setState(() {
          isLoading = false;
        });
      }
      // screen = 3;
      setState(() {});
    } catch (e) {
      print("\n\n$e\n");
      showToast('Something went wrong', backgroundColor: Colors.redAccent);
    }
    // SmartDialog.dismiss();
    setState(() {});
    //return allInfo;
  }

  Widget transferOwnershipWidget() {
    return ListView.builder(
        itemCount: paymenList == null ? 1 : paymenList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Column(
              children: [
                Divider(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '#',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                        'Land Id',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                        child: Center(
                          child: Text('Seller Address',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        flex: 6),
                    Expanded(
                      child: Center(
                        child: Text('Buyer Address',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 6,
                    ),
                    Expanded(
                      child: Center(
                        child: Text('Status',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Center(
                        child: Text('Transfer Ownership',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 3,
                    )
                  ],
                ),
                Divider(
                  height: 15,
                )
              ],
            );
          }
          index -= 1;
          List<dynamic> data = paymenList[index];
          return Container(
            height: 60,
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
            child: Row(
              children: [
                Expanded(
                  child: Text((index + 1).toString()),
                  flex: 1,
                ),
                Expanded(
                    child: Center(
                      child: Text(data[3].toString()),
                    ),
                    flex: 1),
                Expanded(
                    child: Center(
                      child: Text(data[1].toString()),
                    ),
                    flex: 6),
                Expanded(
                    child: Center(child: Text(data[2].toString())), flex: 6),
                Expanded(
                    child: Center(
                        child: data[4].toString() == '3'
                            ? const Text('Payment Done')
                            : const Text('Completed')),
                    flex: 2),
                Expanded(
                    child: Center(
                      child: data[4].toString() == '4'
                          ? const Text('Transfered')
                          : ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () async {
                                SmartDialog.showLoading();
                                try {
                                  List<CameraDescription> camerasList =
                                      await availableCameras();
                                  SmartDialog.dismiss();
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              transferOwnership(
                                                reqId: data[0].toString(),
                                                sellerAdd: data[1].toString(),
                                                landId: data[3].toString(),
                                                buyerAdd: data[2].toString(),
                                                cameraList: camerasList,
                                              )));
                                  await paymentDoneList();
                                } catch (e) {
                                  SmartDialog.dismiss();
                                  showToast(
                                      "Something Went Wrong\n Camera Exception",
                                      context: context,
                                      backgroundColor: Colors.red);
                                }

                                // SmartDialog.showLoading();
                                // try {
                                //   if (connectedWithMetamask)
                                //     await model2.transferOwnership(data[0]);
                                //   else
                                //     await model.transferOwnership(data[0]);
                                //
                                //   await paymentDoneList();
                                //   showToast("Ownership Transfered",
                                //       context: context,
                                //       backgroundColor: Colors.green);
                                // } catch (e) {
                                //   print(e);
                                //   showToast("Something Went Wrong",
                                //       context: context,
                                //       backgroundColor: Colors.red);
                                // }
                                // SmartDialog.dismiss();
                              },
                              icon: const Icon(Icons.arrow_forward_ios),
                              label: const Text('Transfer')),
                    ),
                    flex: 3),
              ],
            ),
          );
        });
  }

  Widget _container(int index) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xFFE7E7E7),
        child: Card(
          color: const Color(0xFFE7E7E7),
          child: Container(

            width: 250,
            height: 140,
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius:BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0)
                  Row(
                    children: [
                      userCount == -1
                          ? const CircularProgressIndicator()
                          : Text(
                              userCount.toString(),
                              style: const TextStyle(fontSize: 24,color: Colors.white),
                            ),
                    ],
                  ),
                if (index == 0)
                  const Flexible(
                    child: Text(
                      'Total Users Registered',
                      style: TextStyle(fontSize: 20,color: Colors.white),
                    ),
                  ),
                if (index == 1)
                  Row(
                    children: [
                      landCount == -1
                          ? const CircularProgressIndicator()
                          : Flexible(
                            child: Text(
                                landCount.toString(),
                                style: const TextStyle(fontSize: 24,color: Colors.white),
                              ),
                          ),
                    ],
                  ),
                if (index == 1)
                  const Flexible(
                    child: Text('Total Property Registered',
                        style: TextStyle(fontSize: 20,color: Colors.white)),
                  ),
                if (index == 2)
                  const Flexible(
                    child: Text('Total Property Transfered ',
                        style: TextStyle(fontSize: 20,color: Colors.white)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget drawer2() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
              blurRadius: 10,
              color: Colors.transparent,
              spreadRadius: 2 )
        ],
        color: Colors.transparent,
      ),
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 245,
            decoration: const BoxDecoration(
                color:Color(0xFFEE5B48),
                borderRadius: BorderRadius.all(
                    Radius.circular(10)) ),
            child: const Padding(
              padding: EdgeInsets.all(50),
              child: Column(
            children: [
                   Icon(
                    Icons.person,
                    size: 50,
                     color: Colors.white60,
                  ),
                Text('Land Inspector',
                    style: TextStyle(
                        color:Color(0xFFFFFFFF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
        ],
      )
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, counter) {
                return const Divider(
                  height: 2,
                );
              },
              itemCount: menuItems.length,
              itemBuilder: (BuildContext context, int index) {
                return MenuItemTile(
                  title: menuItems[index].title,
                  icon: menuItems[index].icon,
                  //animationController: _animationController,
                  isSelected: screen == index,
                  onTap: () {
                    if (index == 4) {
                      Navigator.pop(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const home_page()));
                      Navigator.of(context).pushNamed(
                        '/',
                      );
                    }
                    if (index == 0) getUserCount();
                    if (index == 1) getUserList();
                    if (index == 2) getLandList();
                    if (index == 3) paymentDoneList();
                    setState(() {
                      screen = index;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
