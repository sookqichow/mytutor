import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytutor/constants.dart';
import 'package:mytutor/models/user.dart';
import 'package:mytutor/models/subjects.dart';
import 'package:mytutor/views/cartscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TabsSubjects extends StatefulWidget {
  final User user;
  const TabsSubjects({Key? key, required this.user}) : super(key: key);

  @override
  State<TabsSubjects> createState() => _TabsSubjectsState();
}

class _TabsSubjectsState extends State<TabsSubjects> {
  List<Subject> subList =
      <Subject>[]; //list subject is  dart (json convert dart)
  TextEditingController searchController = TextEditingController();
  String search = "";
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;
  int cart = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadSubjects(1, search);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('Subjects'),
          leading: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => CartScreen(
                              user: widget.user,
                            )));
                _loadSubjects(1, search);
                _loadMyCart();
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ),
              label: Text(widget.user.cart.toString(),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ]),
      backgroundColor: Colors.amber[100],
      body: subList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(children: [
              Padding(
                padding: EdgeInsets.all(2),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      children: List.generate(subList.length, (index) {
                        return InkWell(
                          splashColor: Colors.amber,
                          onTap: () => {_loadProductDetails(index)},
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 5,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/assets/images/courses/" +
                                      subList[index].subjectId.toString() +
                                      '.png',
                                  fit: BoxFit.cover,
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 5,
                                  child: Column(
                                    children: [
                                      Text(
                                        subList[index].subjectName.toString(),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("Price: RM " +
                                          double.parse(subList[index]
                                                  .subjectPrice
                                                  .toString())
                                              .toStringAsFixed(2)),
                                      /* Text(subjectList[index]
                                              .subjectDesc
                                              .toString() ),*/
                                      Text("Sessions: " +
                                          subList[index]
                                              .subjectSessions
                                              .toString() +
                                          " Sessions"),
                                      Text("Rating: " +
                                          subList[index]
                                              .subjectRating
                                              .toString() +
                                          " stars"),
                                    ],
                                  )),
                              Expanded(
                                  flex: 3,
                                  child: IconButton(
                                      onPressed: () {
                                        _addtocartDialog(index);
                                      },
                                      icon: const Icon(Icons.shopping_cart))),
                            ],
                          )),
                        );
                      }))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.orange;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadSubjects(index + 1, "")},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
    );
  }

  void _loadSubjects(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_subjects.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);

      print(jsondata);

      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['subjects'] != null) {
          subList = <Subject>[]; //
          extractdata['subjects'].forEach((v) {
            subList.add(Subject.fromJson(v)); //subjectList php
          });
        } else {
          titlecenter = "No Product Available";
        }
        setState(() {});
      } else {
        //do something
      }
    });
  }

  _loadProductDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Subjects Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/mytutor/assets/images/courses/" +
                      subList[index].subjectId.toString() +
                      '.png',
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  subList[index].subjectName.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Product Description: \n" +
                      subList[index].subjectDesc.toString()),
                  Text("Price: RM " +
                      double.parse(subList[index].subjectPrice.toString())
                          .toStringAsFixed(2)),
                  Text("Sessions Available: " +
                      subList[index].subjectSessions.toString() +
                      " sessions"),
                  Text("Subject Rating: " +
                      subList[index].subjectRating.toString() +
                      " stars"),
                ]),
              ],
            )),
            actions: [
              SizedBox(
                  width: screenWidth / 1,
                  child: ElevatedButton(
                      onPressed: () {
                        _addtocartDialog(index);
                      },
                      child: const Text("Add to cart"))),
            ],
          );
        });
  }

  // void filterSearchResults(String query) {
  //   List<String> dummySearchList = List<String>();
  //   subList.addAll(duplicateItems);
  //   if(query.isNotEmpty) {
  //     List<String> dummyListData = List<String>();
  //     dummySearchList.forEach((subList) {
  //       if(item.contains(query)) {
  //         dummyListData.add(item);
  //       }
  //     });
  //     setState(() {
  //       items.clear();
  //       items.addAll(dummyListData);
  //     });
  //     return;
  //   } else {
  //     setState(() {
  //       items.clear();
  //       items.addAll(duplicateItems);
  //     });
  //   }

  // }

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  //height: screenHeight / 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: "Search",
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)))),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      search = searchController.text;
                      Navigator.of(context).pop();
                      _loadSubjects(1, search);
                    },
                    child: const Text("Search"),
                  )
                ],
              );
            },
          );
        });
  }

  _addtocartDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Add to cart",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                _addtoCart(index);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _loadMyCart() {
    // ignore: avoid_single_cascade_in_expression_statements
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_mycartqty.php"),
        body: {
          "user_email": widget.user.email.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
      }
    });
  }

  void _addtoCart(int index) {
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/insert_cart.php"),
        body: {
          "user_email": widget.user.email.toString(),
          "subject_id": subList[index].subjectId.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); 
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        print(jsondata['data']['carttotal'].toString());
        setState(() {
          widget.user.cart = jsondata['data']['carttotal'].toString();
        });
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
