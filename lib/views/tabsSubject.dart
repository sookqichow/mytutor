import 'package:flutter/material.dart';
import 'package:mytutor/constants.dart';

import 'package:mytutor/models/user.dart';
import 'package:mytutor/constants.dart';
import 'package:mytutor/models/subjects.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TabsSubjects extends StatefulWidget {
  late final User user;

  @override
  State<TabsSubjects> createState() => _TabsSubjectsState();
}

class _TabsSubjectsState extends State<TabsSubjects> {
  List<TabsSubjects> subList =
      <TabsSubjects>[]; //list subject is  dart (json convert dart)
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  var numofpage, curpage = 1;
  var color;

  @override
  void initState() {
    super.initState();
    _loadSubjects(1);
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
      body: subList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(children: [
              const Text("Recommend ",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
              Container(
                color: Colors.orangeAccent,
                child: SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: 3,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Container(
                      height: 80,
                      width: 180,
                      margin: EdgeInsets.all(10),
                      child: CachedNetworkImage(
                        imageUrl: CONSTANTS.server +
                            "/mytutor/assets/images/courses/" + //xampp htdocs
                            subList[index].subjectId.toString() +
                            '.png',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(8)),
              const Text("Subject List ",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      children: List.generate(subList.length, (index) {
                        return InkWell(
                          splashColor: Colors.amber,
                          // onTap: () => {_loadProductDetails(index)},

                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 5,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/mytutor/assets/images/courses/" + //xampp htdocs
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
                                        subList[index]
                                            .subjectName
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("RM " +
                                          double.parse(subList[index]
                                                  .subjectPrice
                                                  .toString())
                                              .toStringAsFixed(2)),
                                      /* Text(subjectList[index]
                                              .subjectDesc
                                              .toString() ),*/
                                      Text(subtList[index]
                                              .subjectSessions
                                              .toString() +
                                          " Sessions"),
                                      Text(subList[index]
                                              .subjectRating
                                              .toString() +
                                          " Rating")
                                    ],
                                  ))
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
                      color = Colors.white;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadSubjects(index + 1)},
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

  void _loadSubjects(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor/mobile/php/load_subjects.php"),
        body: {
          'pageno': pageno.toString(),
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
          subList = <TabsSubjects>[]; //
          extractdata['subjects'].forEach((v) {
            subList.add(TabsSubjects.fromJson(v)); //subjectList php
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
}
