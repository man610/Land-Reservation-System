import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:provider/provider.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:http/http.dart' as http;
import '../../constant/constants.dart';
import '../../constant/loadingScreen.dart';
import '../../constant/utils.dart';
import '../../providers/LandRegisterModel.dart';
import '../../providers/MetaMaskProvider.dart';
import '../../widget/header_user.dart';
import '../../widget/landContainer.dart';
import '../../widget/menu_item_tile.dart';
import '../ChooseLandMap.dart';
import '../viewLandDetails.dart';


class DashBoardTest extends StatefulWidget {
  const DashBoardTest({Key? key}) : super(key: key);

  @override
  _DashBoardTestState createState() => _DashBoardTestState();
}

class _DashBoardTestState extends State<DashBoardTest> {
  var model, model2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int screen = 0;
  late List<dynamic> userInfo;
  bool isLoading = true, isUserVerified = false;
  bool isUpdated = true;
  double scrWidth = 0.0;
  double scrHeight = 0.0;
  List<List<dynamic>> LandGall = [];
  String name = "";

  final _formKey = GlobalKey<FormState>();
  late String area,
      landAddress,
      landPrice,
      propertyID,
      surveyNo,
      document,
      allLatiLongi;
  List<List<dynamic>> landInfo = [];
  List<List<dynamic>> receivedRequestInfo = [];
  List<List<dynamic>> sentRequestInfo = [];
  List<dynamic> prices = [];
  List<Menu> menuItems = [
    Menu(title: 'DashBoardTest', icon: Icons.dashboard),
    Menu(title: 'Add Lands', icon: Icons.add_chart),
    Menu(title: 'My Lands', icon: Icons.landscape_rounded),
    Menu(title: 'Land Gallery', icon: Icons.landscape_rounded),
    // Menu(title: 'My Received Request', icon: Icons.request_page_outlined),
    // Menu(title: 'My Sent Land Request', icon: Icons.request_page_outlined),
    Menu(title: 'Transactions', icon: Icons.transfer_within_a_station),
    Menu(title: 'Logout', icon: Icons.logout),
    Menu(title: 'My Received Request', icon: Icons.request_page_outlined),
    Menu(title: 'My Sent Land Request', icon: Icons.request_page_outlined),
  ];
  Map<String, String> requestStatus = {
    '0': 'Pending',
    '1': 'Accepted',
    '2': 'Rejected',
    '3': 'Payment Done',
    '4': 'Completed'
  };

  List<MapBoxPlace> predictions = [];
  late PlacesSearch placesSearch;
  final FocusNode _focusNode = FocusNode();
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  TextEditingController addressController = TextEditingController();

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
        builder: (context) => Positioned(
          width: 540,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0.0, 40 + 5.0),
            child: Material(
              elevation: 4.0,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: List.generate(
                    predictions.length,
                        (index) => ListTile(
                      title:
                      Text(predictions[index].placeName.toString()),
                      onTap: () {
                        addressController.text =
                            predictions[index].placeName.toString();

                        setState(() {});
                        _overlayEntry.remove();
                        _overlayEntry.dispose();
                      },
                    )),
              ),
            ),
          ),
        ));
  }

  Future<void> autocomplete(value) async {
    List<MapBoxPlace>? res = await placesSearch.getPlaces(value);
    if (res != null) predictions = res;
    setState(() {});
    // print(res);
    // print(res![0].placeName);
    // print(res![0].geometry!.coordinates);
    // print(res![0]);
  }

  @override
  void initState() {
    placesSearch = PlacesSearch(
      apiKey: mapBoxApiKey,
      limit: 10,
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
    super.initState();
  }

  getLandInfo() async {
    setState(() {
      landInfo = [];
      isLoading = true;
    });
    List<dynamic> landList;
    if (connectedWithMetamask) {
      landList = await model2.myAllLands();
    } else {
      landList = await model.myAllLands();
    }

    List<List<dynamic>> info = [];
    List<dynamic> temp;
    for (int i = 0; i < landList.length; i++) {
      if (connectedWithMetamask) {
        temp = await model2.landInfo(landList[i]);
      } else {
        temp = await model.landInfo(landList[i]);
      }
      landInfo.add(temp);
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  getLandGallery() async {
    setState(() {
      isLoading = true;
      LandGall = [];
    });
    List<dynamic> landList;
    if (connectedWithMetamask) {
      landList = await model2.allLandList();
    } else {
      landList = await model.allLandList();
    }

    // List<List<dynamic>> allInfo = [];
    List<dynamic> temp;
    for (int i = 0; i < landList.length; i++) {
      if (connectedWithMetamask) {
        temp = await model2.landInfo(landList[i]);
      } else {
        temp = await model.landInfo(landList[i]);
      }
      LandGall.add(temp);
      setState(() {
        isLoading = false;
      });
    }
    // screen = 3;
    isLoading = false;
    setState(() {});
  }

  getMySentRequest() async {
    //SmartDialog.showLoading();
    sentRequestInfo = [];
    setState(() {
      isLoading = true;
    });
    await getEthToInr();
    List<dynamic> requestList;
    if (connectedWithMetamask) {
      requestList = await model2.mySentRequest();
    } else {
      requestList = await model.mySentRequest();
    }

    List<dynamic> temp;
    var pri;
    for (int i = 0; i < requestList.length; i++) {
      if (connectedWithMetamask) {
        temp = await model2.requestInfo(requestList[i]);
        pri = await model2.landPrice(temp[3]);
      } else {
        temp = await model.requestInfo(requestList[i]);
        pri = await model.landPrice(temp[3]);
      }
      prices.add(pri);
      sentRequestInfo.add(temp);
      isLoading = false;

      // SmartDialog.dismiss();
      setState(() {});
    }

    // screen = 5;
    isLoading = false;

    // SmartDialog.dismiss();
    setState(() {});
  }

  getMyReceivedRequest() async {
    receivedRequestInfo = [];
    setState(() {
      isLoading = true;
    });
    List<dynamic> requestList;
    if (connectedWithMetamask) {
      requestList = await model2.myReceivedRequest();
    } else {
      requestList = await model.myReceivedRequest();
    }

    List<dynamic> temp;
    for (int i = 0; i < requestList.length; i++) {
      if (connectedWithMetamask) {
        temp = await model2.requestInfo(requestList[i]);
      } else {
        temp = await model.requestInfo(requestList[i]);
      }
      receivedRequestInfo.add(temp);
      isLoading = false;
      setState(() {});
    }
    isLoading = false;
    //  screen = 4;
    setState(() {});
  }

  Future<void> getProfileInfo() async {
    // setState(() {
    //   isLoading = true;
    // });
    if (connectedWithMetamask) {
      userInfo = await model2.myProfileInfo();
    } else {
      userInfo = await model.myProfileInfo();
    }
    name = userInfo[1];
    setState(() {
      isLoading = false;
    });
  }

  String docuName = "";
  late PlatformFile documentFile;
  String cid = "", docUrl = "";
  bool isFilePicked = false;

  pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf'],
    );

    if (result != null) {
      isFilePicked = true;
      docuName = result.files.single.name;
      documentFile = result.files.first;
    }
    setState(() {});
  }

  Future<bool> uploadDocument() async {
    String url = "https://api.nft.storage/upload";
    var header = {"Authorization": "Bearer $nftStorageApiKey"};

    if (isFilePicked) {
      try {
        final response = await http.post(Uri.parse(url),
            headers: header, body: documentFile.bytes);
        var data = jsonDecode(response.body);
        //print(data);
        if (data['ok']) {
          cid = data["value"]["cid"];
          docUrl = "https://" + cid + ".ipfs.dweb.link";

          return true;
        }
      } catch (e) {
        print(e);
        showToast("Something went wrong,while document uploading",
            context: context, backgroundColor: Colors.red);
      }
    } else {
      showToast("Choose Document",
          context: context, backgroundColor: Colors.red);
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    scrWidth = MediaQuery.of(context).size.width;
    scrHeight = MediaQuery.of(context).size.height;

    model = Provider.of<LandRegisterModel>(context);
    model2 = Provider.of<MetaMaskProvider>(context);
    if (isUpdated) {
      getProfileInfo();
      isUpdated = false;
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
          child:  Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              toolbarHeight: 0,
              centerTitle: false,
              // title: isDesktop ? null : Text('My App Title'),
              backgroundColor: const Color(0xFF272D34),
              leading: !isDesktop
                  ? GestureDetector(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ), //AnimatedIcon(icon: AnimatedIcons.menu_arrow,progress: _animationController,),
                ),
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              )
                  : Container(),
            ),
            drawer: drawer2(),
            drawerScrimColor: Colors.transparent,
            body: Row(
              children: [
                isDesktop ? drawer2() : Container(),
                if (screen == 0)
                  userProfile()
                else if (screen == 1)
                  addLand()
                else if (screen == 2)
                    myLands()
                  else if (screen == 3)
                      landGallery()
                    else if (screen == 7)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(25),
                            child: receivedRequest(),
                          ),
                        )
                      else if (screen == 6)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(25),
                              child: sentRequest(),
                            ),
                          )
              ],
            ),
          ),
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

  Widget sentRequest() {

    return ListView.builder(
      itemCount: sentRequestInfo == null ? 1 : sentRequestInfo.length + 1,
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
                    child: Text(
                      'Land Id',
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
                      child: Text('Status',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Price(in ₹)',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Make Payment',
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
        List<dynamic> data = sentRequestInfo[index];
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
              Expanded(child: Center(child: Text(data[3].toString())), flex: 1),
              Expanded(
                  child: Center(
                    child: Text(data[1].toString()),
                  ),
                  flex: 5),
              Expanded(
                  child: Center(
                    child: Text(requestStatus[data[4].toString()].toString()),
                  ),
                  flex: 3),
              Expanded(
                  child: Center(
                    child: Text(prices[index].toString()),
                  ),
                  flex: 2),
              Expanded(
                  child: Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        onPressed: data[4].toString() != '1'
                            ? null
                            : () async {
                          _paymentDialog(
                              data[2],
                              data[1],
                              prices[index].toString(),
                              double.parse(prices[index].toString()) /
                                  ethToInr,
                              ethToInr,
                              data[0]);
                          // SmartDialog.showLoading();
                          // try {
                          //   //await model.rejectRequest(data[0]);
                          //   //await getMyReceivedRequest();
                          // } catch (e) {
                          //   print(e);
                          // }
                          //
                          // //await Future.delayed(Duration(seconds: 2));
                          // SmartDialog.dismiss();
                        },
                        child: const Text('Make Payment')),
                  ),
                  flex: 2),
            ],
          ),
        );
      },
    );
  }

  Widget receivedRequest() {

    return ListView.builder(
      itemCount:
      receivedRequestInfo == null ? 1 : receivedRequestInfo.length + 1,
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
                    child: Text(
                      'Land Id',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                      child: Center(
                        child: Text('Buyer Address',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      flex: 5),
                  Expanded(
                    child: Center(
                      child: Text('Status',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 3,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Payment Done',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Reject',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Accept',
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
        List<dynamic> data = receivedRequestInfo[index];
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
              Expanded(child: Center(child: Text(data[3].toString())), flex: 1),
              Expanded(
                  child: Center(
                    child: Text(data[2].toString()),
                  ),
                  flex: 5),
              Expanded(
                  child: Center(
                    child: Text(requestStatus[data[4].toString()].toString()),
                  ),
                  flex: 3),
              Expanded(child: Center(child: Text(data[5].toString())), flex: 2),
              Expanded(
                  child: Center(
                    child: ElevatedButton(
                        style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        onPressed: data[4].toString() != '0'
                            ? null
                            : () async {
                          SmartDialog.showLoading();
                          try {
                            if (connectedWithMetamask) {
                              await model2.rejectRequest(data[0]);
                            } else {
                              await model.rejectRequest(data[0]);
                            }
                            await getMyReceivedRequest();
                          } catch (e) {
                            print(e);
                          }

                          //await Future.delayed(Duration(seconds: 2));
                          SmartDialog.dismiss();
                        },
                        child: const Text('Reject')),
                  ),
                  flex: 2),
              Expanded(
                  child: Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent),
                        onPressed: data[4].toString() != '0'
                            ? null
                            : () async {
                          SmartDialog.showLoading();
                          try {
                            if (connectedWithMetamask) {
                              await model2.acceptRequest(data[0]);
                            } else {
                              await model.acceptRequest(data[0]);
                            }
                            await getMyReceivedRequest();
                          } catch (e) {
                            print(e);
                          }

                          //await Future.delayed(Duration(seconds: 2));
                          SmartDialog.dismiss();
                        },
                        child: const Text('Accept')),
                  ),
                  flex: 2),
            ],
          ),
        );
      },
    );
  }


  Widget landGallery() {
    if (isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }

    if (LandGall.isEmpty) {
      return const Expanded(
          child: Center(
              child: Text(
                'No Lands Added yet',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              )));
    }
    return Expanded(
      child: Center(
        child: SizedBox(
          width: isDesktop ? 900 : width,
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 440,
                crossAxisCount: isDesktop ? 2 : 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: LandGall.length,
            itemBuilder: (context, index) {
              return landWid2(
                  LandGall[index][10],
                  LandGall[index][1].toString(),
                  LandGall[index][2].toString(),
                  LandGall[index][3].toString(),
                  LandGall[index][9] == userInfo[0],
                  LandGall[index][8], () async {
                if (isUserVerified) {
                  SmartDialog.showLoading();
                  try {
                    if (connectedWithMetamask) {
                      await model2.sendRequestToBuy(LandGall[index][0]);
                    } else {
                      await model.sendRequestToBuy(LandGall[index][0]);
                    }
                    showToast("Request sent",
                        context: context, backgroundColor: Colors.green);
                  } catch (e) {
                    print(e);
                    showToast("Something Went Wrong",
                        context: context, backgroundColor: Colors.red);
                  }
                  SmartDialog.dismiss();
                } else {
                  showToast("You are not verified",
                      context: context, backgroundColor: Colors.red);
                }
              }, () {
                List<String> allLatiLongi =
                LandGall[index][4].toString().split('|');

                LandInfo landinfo = LandInfo(
                    LandGall[index][1].toString(),
                    LandGall[index][2].toString(),
                    LandGall[index][3].toString(),
                    LandGall[index][5].toString(),
                    LandGall[index][6].toString(),
                    LandGall[index][7].toString(),
                    LandGall[index][8],
                    LandGall[index][9].toString(),
                    LandGall[index][10]);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => viewLandDetails(
                          allLatitude: allLatiLongi[0],
                          allLongitude: allLatiLongi[1],
                          landinfo: landinfo,
                        )));
              });
            },
          ),
        ),
      ),
    );
  }

  Widget myLands() {
    if (isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    if (landInfo.isEmpty) {
      return const Expanded(
          child: Center(
              child: Text(
                'No Lands Added yet',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              )));
    }
    return Expanded(
      child: Center(
        child: SizedBox(
          width: isDesktop ? 900 : width,
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 440,
                crossAxisCount: isDesktop ? 2 : 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: landInfo.length,
            itemBuilder: (context, index) {
              return landWid(
                  landInfo[index][10],
                  landInfo[index][1].toString(),
                  landInfo[index][2].toString(),
                  landInfo[index][3].toString(),
                  landInfo[index][8],
                      () =>
                      confirmDialog('Are you sure to make it on sell?', context,
                              () async {
                            SmartDialog.showLoading();
                            if (connectedWithMetamask) {
                              await model2.makeForSell(landInfo[index][0]);
                            } else {
                              await model.makeForSell(landInfo[index][0]);
                            }
                            Navigator.pop(context);
                            await getLandInfo();
                            SmartDialog.dismiss();
                          }));
            },
          ),
        ),
      ),
    );
  }

  Widget addLand() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        //color: Color(0xFFBb3b3cc),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.amber),
          color: const Color(0xfff5f0e1)
      ),
      width:isDesktop ? scrWidth-255 : scrWidth,
      child:  Form(
        key: _formKey,
        child: Column(
          verticalDirection: VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              widthFactor:scrWidth ,
              child:  const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Land Registration Form',
                  style: TextStyle(
                      color: Colors.brown,
                      fontSize: 25,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ),
              alignment: Alignment.topCenter,
            ),
            SizedBox(
              width: isDesktop ? 500 : scrWidth/2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    area = val;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  decoration: const InputDecoration(
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(),
                    labelText: 'Area(SqFt)',
                    hintText: 'Enter Area in SqFt',
                  ),
                ),
              ),
            ),
            SizedBox(
              width: isDesktop ? 500 : scrWidth/2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: CompositedTransformTarget(
                  link: _layerLink,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Land Address';
                      }
                      return null;
                    },
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    controller: addressController,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        autocomplete(value);
                        _overlayEntry.remove();
                        _overlayEntry = _createOverlayEntry();
                        Overlay.of(context).insert(_overlayEntry);
                      } else {
                        if (predictions.isNotEmpty && mounted) {
                          setState(() {
                            predictions = [];
                          });
                        }
                      }
                    },
                    focusNode: _focusNode,
                    //obscureText: true,
                    decoration: const InputDecoration(
                      isDense: true, // Added this
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                      hintText: 'Enter Land Address',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: isDesktop ? 500 : scrWidth/2,
              child: Container(
                width:isDesktop ? 500 : scrWidth/2 ,
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Land Price';
                    }
                    return null;
                  },
                  //maxLength: 12,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  onChanged: (val) {
                    landPrice = val;
                  },
                  //obscureText: true,
                  decoration: const InputDecoration(
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(),
                    labelText: 'Land Price',
                    hintText: 'Enter Land Price',
                  ),
                ),
              ),
            ),
            SizedBox(
              width: isDesktop ? 500 : scrWidth/2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter PID';
                    }
                    return null;
                  },
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  //maxLength: 10,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  onChanged: (val) {
                    propertyID = val;
                  },
                  //obscureText: true,
                  decoration: const InputDecoration(
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(),
                    labelText: 'PID',
                    hintText: 'Enter Property ID',
                  ),
                ),
              ),
            ),
            SizedBox(
              width: isDesktop ? 500 : scrWidth/2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (val) {
                    surveyNo = val;
                  },
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  //obscureText: true,
                  decoration: const InputDecoration(
                    isDense: true, // Added this
                    contentPadding: EdgeInsets.all(12),
                    border: OutlineInputBorder(),
                    labelText: 'Survey No.',
                    hintText: 'Survey No.',
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10),
            //   child:
            // ),
            SizedBox(
              width: isDesktop ? 500 : scrWidth/2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      color: Colors.grey,
                      onPressed: pickDocument,
                      child: const Text('Upload Document'),
                    ),
                    Text(docuName),
                    MaterialButton(
                      color: const Color(0xFF603500),
                      shape:const StadiumBorder(side: BorderSide(style: BorderStyle.solid)),
                      textColor: const Color(0xFFEEE2D4),
                      padding: const EdgeInsets.all(20),
                      onPressed: () async {
                        allLatiLongi = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const landOnMap()));
                        if (allLatiLongi.isEmpty || allLatiLongi == "") {
                          showToast("Please select area on map",
                              context: context, backgroundColor: Colors.red);
                        }
                        //print(res);
                      },
                      child: const Text('Draw Land on Map'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: isDesktop ? 500 : scrWidth/2,
              child: CustomButton(
                  'Add',
                  isLoading || !isUserVerified
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate() &&
                        allLatiLongi.isNotEmpty &&
                        allLatiLongi != "") {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        SmartDialog.showLoading(
                            msg: "Uploading Document");
                        bool isFileupload = await uploadDocument();
                        SmartDialog.dismiss();
                        if (isFileupload) {
                          if (connectedWithMetamask) {
                            await model2.addLand(
                                area,
                                addressController.text,
                                allLatiLongi,
                                landPrice,
                                propertyID,
                                surveyNo,
                                docUrl
                            );
                          } else {
                            await model.addLand(
                                area,
                                addressController.text,
                                allLatiLongi,
                                landPrice,
                                propertyID,
                                surveyNo,
                                docUrl);
                          }
                          showToast("Land Successfully Added",
                              context: context,
                              backgroundColor: Colors.green);
                          isFilePicked = false;
                        }
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

                    //model.makePaymentTestFun();
                  }),
            ),
            if (!isUserVerified)
              const Text('You are not verified',
                  style: TextStyle(color: Colors.redAccent)),
            isLoading ? spinkitLoader : Container()
          ],
        ),
      ),
    );
  }

  Widget userProfile() {
    if (isLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    isUserVerified = userInfo[8];
    return Expanded(
      child: Center(
        child: Container(
          width: scrWidth,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xffbb3b3cc),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Profile',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              userInfo[8]
                  ? const Row(
                children: [
                  Text(
                    'Verified',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  Icon(
                    Icons.verified,
                    color: Colors.green,
                  )
                ],
              )
                  : const Text(
                'Not Yet Verified',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              CustomTextFiled(userInfo[0].toString(), 'Wallet Address',400),
              CustomTextFiled(userInfo[1].toString(), 'Name',400),
              CustomTextFiled(userInfo[2].toString(), 'Age',100),
              CustomTextFiled(userInfo[3].toString(), 'City',200),
              CustomTextFiled(userInfo[4].toString(), 'Aadhar Number',300),
              CustomTextFiled(userInfo[5].toString(), 'Pan',300),
              TextButton(
                onPressed: () {
                  launchUrl(userInfo[6].toString());
                },
                child: const Text(
                  '  View Document',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              CustomTextFiled(userInfo[7].toString(), 'Mail',200),
            ],
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
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, counter) {
                return const Divider(
                  color:Colors.transparent ,
                  height: 2,
                );
              },
              itemCount: menuItems.length-2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 4) {
                  bool isSelected4;
                  if (index==4){ isSelected4=true;}else{isSelected4=false;}
                  // Return ExpansionTile widget for the dropdown menu
                  return Container(
                    width: 70, //_animation.value,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE3341C),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(10)
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: ExpansionTile(
                      title:Row(
                        children: [
                          Icon(
                            Icons.logout,
                            color: isSelected4 ?Colors.white : Colors.white60,
                            size: 38,
                          ),
                          const SizedBox(width: 0),
                          Text('Transaction',
                              style: isSelected4
                                  ? const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)
                                  : const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300)),
                        ],
                      ),
                      children: [
                        // List of items in the dropdown menu
                        ListBody(children: [
                          MenuItemTile(

                            title: menuItems[7].title,
                            icon: menuItems[7].icon,
                            isSelected: screen == 7,
                            onTap: () {
                              getMySentRequest();
                              setState(() {
                                screen = 7;
                              });
                            },
                          ),
                          MenuItemTile(
                            title: menuItems[6].title,
                            icon: menuItems[6].icon,
                            isSelected: screen == 6,
                            onTap: () {
                              getMySentRequest();
                              setState(() {
                                screen = 6;
                              });
                            },
                          ),],)

                      ],
                    ),
                  );
                } else {
                  // Return MenuItemTile widget for all other menu items
                  return MenuItemTile(
                    title: menuItems[index].title,
                    icon: menuItems[index].icon,
                    isSelected: screen == index,
                    onTap: () {
                      if (index == 5) {
                        Navigator.pop(context);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const home_page()));
                        Navigator.of(context).pushNamed(
                          '/',
                        );
                      }
                      if (index == 0) getProfileInfo();
                      if (index == 2) getLandInfo();
                      if (index == 3) getLandGallery();
                      if (index == 6) getMySentRequest();
                      if (index == 7) getMyReceivedRequest();
                      setState(() {
                        screen = index;
                      });
                    },
                  );
                }
              },
            ),
          ),

        ],
      ),
    );
  }

  _paymentDialog(buyerAdd, sellAdd, amountINR, total, ethval, reqID) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.white,
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 430.0,
                width: 320,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'Confirm Payment',
                      style: TextStyle(fontSize: 30),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      buyerAdd.toString(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Icon(
                      Icons.arrow_circle_down,
                      size: 30,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      sellAdd.toString(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Total Amount in ₹",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      amountINR,
                      style: const TextStyle(fontSize: 30),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      '1 ETH = ' + ethval.toString() + '₹',
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Total ETH:",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      total.toString(),
                      style: const TextStyle(fontSize: 30),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomButton3('Cancel', () {
                          Navigator.of(context).pop();
                        }, Colors.white),
                        CustomButton3('Confirm', () async {
                          SmartDialog.showLoading();
                          try {
                            if (connectedWithMetamask) {
                              await model2.makePayment(reqID, total);
                            } else {
                              await model.makePayment(reqID, total);
                            }
                            await getMySentRequest();
                            showToast("Payment Success",
                                context: context,
                                backgroundColor: Colors.green);
                          } catch (e) {
                            print(e);
                            showToast("Something Went Wrong",
                                context: context, backgroundColor: Colors.red);
                          }
                          SmartDialog.dismiss();
                          Navigator.of(context).pop();
                        }, Colors.blue)
                      ],
                    )
                  ],
                ),
              ));
        });
  }
}
