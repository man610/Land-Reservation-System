import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:land_registration/providers/LandRegisterModel.dart';
import 'package:land_registration/widget/menu_item_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../constant/utils.dart';
import '../providers/MetamaskProvider.dart';
import '../widget/header_user.dart';

class AddLandInspector extends StatefulWidget {
  const AddLandInspector({Key? key}) : super(key: key);

  @override
  _AddLandInspectorState createState() => _AddLandInspectorState();
}

class _AddLandInspectorState extends State<AddLandInspector> {
  late String address, name, age, desig, city, newaddress;
  var model, model2;
  double scrWidth = 0.0;
  double scrHeight = 0.0;
  double width = 600;
  int screen = 0;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFirstTimeLoad = true;
  dynamic userCount = -1, landCount = -1;

  List<Menu> menuItems = [
    Menu(title: 'Add Land Inspector', icon: Icons.person_add),
    Menu(title: 'All Land Inspectors', icon: Icons.group),
    Menu(title: 'Change Contract Owner', icon: Icons.change_circle),
    Menu(title: 'Logout', icon: Icons.logout),
  ];

  List<List<dynamic>> allLandInspectorInfo = [];
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
    if (kIsWeb) {
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
          top: scrHeight * 0.10,
          height: scrHeight * 0.90,
          child: Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            // appBar: AppBar(
            //   centerTitle: false,
            //   backgroundColor: const Color(0xFF272D34),
            //   leading: !isDesktop
            //       ? Container()
            //       : GestureDetector(
            //           child: const Padding(
            //             padding: EdgeInsets.all(8.0),
            //             child: Icon(
            //               Icons.menu,
            //               color: Colors.black,
            //             ), //AnimatedIcon(icon: AnimatedIcons.menu_arrow,progress: _animationController,),
            //           ),
            //           onTap: () {
            //             _scaffoldKey.currentState!.openDrawer();
            //           },
            //         ),

            // ),
            drawer: drawer2(),
            drawerScrimColor: Colors.transparent,
            body: Row(
              children: [
                isDesktop ? drawer2() : Container(),
                if (screen == 0)
                  addLandInspector()
                else if (screen == 1)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      child: landInspectorList(),
                    ),
                  )
                else if (screen == 2)
                  changeContractOwner()
              ],
            ),
          ),
        ),
        Positioned(
          height: scrHeight * 0.10,
          width: scrWidth,
          child: const Material(
            elevation: 10,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: HeaderUserWidget(),
            ),
          ),
        ),
        Positioned(
          left: 0,
          width: scrWidth * 0.2,
          bottom: 0,
          child: Padding(
              padding: const EdgeInsets.all(0),
              child: (Image.asset(
                'assets/background_image.png',
                width: scrWidth * 0.3,
                fit: BoxFit.scaleDown,
                color: const Color.fromRGBO(255, 255, 255, 0.4),
                colorBlendMode: BlendMode.modulate,
                alignment: Alignment.bottomLeft,
              ))),
        )
      ],
    );
  }

  getLandInspectorInfo() async {
    setState(() {
      isLoading = true;
    });
    List<dynamic> landList;
    if (connectedWithMetamask) {
      landList = await model2.allLandInspectorList();
    } else {
      landList = await model.allLandInspectorList();
    }

    List<List<dynamic>> info = [];
    List<dynamic> temp;
    for (int i = 0; i < landList.length; i++) {
      if (connectedWithMetamask) {
        temp = await model2.landInspectorInfo(landList[i]);
      } else {
        temp = await model.landInspectorInfo(landList[i]);
      }
      info.add(temp);
    }
    allLandInspectorInfo = info;
    setState(() {
      isLoading = false;
    });
    print(info);
  }

  Widget landInspectorList() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    return ListView.builder(
      itemCount:
          allLandInspectorInfo == null ? 1 : allLandInspectorInfo.length + 1,
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
                        child: Text('LandInspector\'s Address',
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
                      child: Text('City',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Remove',
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
        List<dynamic> data = allLandInspectorInfo[index];
        return ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text((index + 1).toString()),
                flex: 1,
              ),
              Expanded(
                  child: Center(
                    child: Text(data[1].toString()),
                  ),
                  flex: 5),
              Expanded(
                  child: Center(
                    child: Text(data[2].toString()),
                  ),
                  flex: 3),
              Expanded(
                  child: Center(
                    child: Text(data[5].toString()),
                  ),
                  flex: 2),
              Expanded(
                  child: Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () async {
                          confirmDialog('Are you sure to remove?', context,
                              () async {
                            SmartDialog.showLoading();
                            if (connectedWithMetamask) {
                              await model2.removeLandInspector(data[1]);
                            } else {
                              await model.removeLandInspector(data[1]);
                            }
                            Navigator.pop(context);
                            await getLandInspectorInfo();
                            SmartDialog.dismiss();
                          });
                        },
                        child: const Text('Remove')),
                  ),
                  flex: 2),
            ],
          ),
        );
      },
    );
  }

  Widget changeContractOwner() {
    return Center(
      widthFactor: isDesktop ? 2 : 1,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              const Text(
                "Change Contract Owner",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    newaddress = val;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                    hintText: 'Enter new Contract Owner Address',
                  ),
                ),
              ),
              CustomButton(
                  'Change',
                  isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            if (connectedWithMetamask) {
                              await model2.changeContractOwner(newaddress);
                            } else {
                              await model.changeContractOwner(newaddress);
                            }
                            showToast("Successfully Changed",
                                context: context,
                                backgroundColor: Colors.green);
                          } catch (e) {
                            print(e);
                            showToast("Something Went Wrong",
                                context: context, backgroundColor: Colors.red);
                          }
                          setState(() {
                            isLoading = false;
                          });
                        }),
              isLoading ? const CircularProgressIndicator() : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget addLandInspector() {
    return Center(
      widthFactor: isDesktop ? 2 : 1,
      child: Container(
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(

            //color: Color(0xFFBb3b3cc),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.amber),
            color: const Color(0xfff5f0e1)),
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  widthFactor: scrWidth,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 50),
                    child: Text(
                      'Add Land Inspector',
                      style: TextStyle(
                          color: Colors.brown,
                          fontSize: 25,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  alignment: Alignment.topCenter,
                ),
                SizedBox(
                  width: isDesktop ? 500 : scrWidth * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Address: ', style: TextStyle(fontSize: 18)),
                      Flexible(
                        child: SizedBox(
                          width: isDesktop ? 375 : scrWidth * 0.8,
                        
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                address = val;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Address',
                                hintText:
                                    'Enter Land Inspector Address(0xc5aEabE793B923981fc401bb8da620FDAa45ea2B)',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: isDesktop ? 500 : scrWidth * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Name:', style: TextStyle(fontSize: 18)),
                      Flexible(
                        child: SizedBox(
                          width: isDesktop ? 375 : scrWidth * 0.8,
                        
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                name = val;
                              },
                              //obscureText: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Name',
                                hintText: 'Enter Name',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: isDesktop ? 500 : scrWidth * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Age:', style: TextStyle(fontSize: 18)),
                      Flexible(
                        child: SizedBox(
                          width: isDesktop ? 375 : scrWidth * 0.8,
                        
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                age = val;
                              },
                              //obscureText: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Age',
                                hintText: 'Enter Age',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: isDesktop ? 500 : scrWidth * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Designation:', style: TextStyle(fontSize: 18)),
                      Flexible(
                        child: SizedBox(
                          width: isDesktop ? 375 : scrWidth * 0.8,
                        
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                desig = val;
                              },
                              //obscureText: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Designation',
                                hintText: 'Enter Designation',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: isDesktop ? 500 : scrWidth * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('City :', style: TextStyle(fontSize: 18)),
                      Flexible(
                        child: SizedBox(
                          width: isDesktop ? 375 : scrWidth * 0.8,
                        
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onChanged: (val) {
                                city = val;
                              },
                              //obscureText: true,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'City',
                                hintText: 'Enter City',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                    'Add',
                    isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                if (connectedWithMetamask) {
                                  await model2.addLandInspector(
                                      address, name, age, desig, city);
                                } else {
                                  await model.addLandInspector(
                                      address, name, age, desig, city);
                                }
                                showToast("Successfully Added",
                                    context: context,
                                    backgroundColor: Colors.green);
                              } catch (e) {
                                print(e);
                                showToast("Something Went Wrong",
                                    context: context,
                                    backgroundColor: Colors.red);
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }),
                isLoading ? const CircularProgressIndicator() : Container()
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
          BoxShadow(blurRadius: 10, color: Colors.transparent, spreadRadius: 2)
        ],
        color: Colors.transparent,
      ),
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: 30,
          ),
          const Icon(
            Icons.person,
            size: 50,
          ),
          const SizedBox(
            width: 30,
          ),
          const Text('Contract Owner',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 40,
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
                  isSelected: screen == index,
                  onTap: () {
                    if (index == 3) {
                      Navigator.pop(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => home_page()));
                      Navigator.of(context).pushNamed(
                        '/',
                      );
                    }
                    if (index == 1) getLandInspectorInfo();

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
