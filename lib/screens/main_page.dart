// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:doginer/models/accessories.dart';
import 'package:doginer/common/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doginer/models/course.dart';
import 'package:doginer/screens/course_page.dart';
import 'package:doginer/screens/main_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    var body = new Scaffold(
        // appBar: new AppBar(
        //   title: new Text("Doginer"),
        //   elevation: 0.0,
        //   backgroundColor: Colors.transparent,
        //   actions: <Widget>[
        //     new IconButton(icon: new Icon(Icons.shopping_cart, color: Colors.white,), onPressed: (){})
        //   ],
        // ),
        body: new Container(
          decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.1, 0.9],
              colors: [
              // Colors are easy thanks to Flutter's Colors class.
                gradientColor1,
                gradientColor2,
              ],
            )
          ),
          child: new Stack(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.only(top: 10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(child:
                      new ListView(
                        children: [
                          new Padding(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: Text('Courses',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                          _CourseModule(),
                          Divider(
                            color: Colors.grey[700],
                            indent: 20,
                            endIndent: 20
                          ),
                          new Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                              child: Text('Exercises',
                                  style: TextStyle(fontSize: 20))),
                          _ExerciseModule(),
                          Divider(
                              color: Colors.grey[700],
                              indent: 20,
                              endIndent: 20
                          ),
                          new Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                              child: Text('Accessories',
                                  style: TextStyle(fontSize: 20))),
                          _AccessoriesModule()
                        ],
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
    );

    return body;
  }
}


class _CourseModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;


    var c = Provider.of<CourseNotifier>(context, listen: true);

    final courseList = new ListView.builder(
      itemBuilder: (context, index) => _CourseItem(index),
      scrollDirection: Axis.horizontal,
      itemCount: c.getSize()
    );

    return new Container(height: 200.0, width: _width, child: courseList);
  }
}


class _ExerciseModule extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    var c = Provider.of<CourseNotifier>(context, listen: true);

    final courseList = new ListView.builder(
        itemBuilder: (context, index) => ExerciseItem(index+100, index),
        scrollDirection: Axis.horizontal,
        itemCount: c.getAllExercises().length
    );

    return new Container(height: 200.0, width: _width, child: courseList);
  }
}


class _AccessoriesModule extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final courseList = new ListView.builder(
        itemBuilder: (context, index) => AccessoriesItem(index),
        scrollDirection: Axis.horizontal,
        itemCount: context.select((AccessoriesNotifier cn) => cn.getSize())
    );

    return new Container(height: 200.0, width: _width, child: courseList);
  }
}

class _CourseItem extends StatelessWidget {
  final int index;

  _CourseItem(this.index, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = index == 0 ? const EdgeInsets.only(
        left: 20.0, right: 10.0, top: 4.0, bottom: 30.0) : const EdgeInsets
        .only(
        left: 10.0, right: 10.0, top: 4.0, bottom: 30.0);

    var course = context.select((CourseNotifier cn) => cn.getByPosition(this.index));

    Color statusBorderColor;
    Color statusColor;
    switch(course.status) {
      case "New": {
        statusBorderColor = Colors.white;
        statusColor = Colors.transparent;
      }
      break;

      case "Completed": {
        statusBorderColor = Colors.green.withOpacity(0.8);
        statusColor = statusBorderColor;
      }
      break;

      case "In progress": {
        statusBorderColor = Colors.grey.withOpacity(0.8);
        statusColor = Colors.grey.withOpacity(0.2);
      }
      break;

      default: {
        statusBorderColor = Colors.white;
        statusColor = Colors.transparent;
      }
      break;
    }

    return new Padding(
      padding: padding,
      child: new InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoursePage(course: course),
              ));
        },
        child: new Stack(
          children: [
            new Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(10.0),
                color: course.color,
                boxShadow: [
                  new BoxShadow(
                      color: Colors.black.withAlpha(70),
                      offset: const Offset(3.0, 10.0),
                      blurRadius: 15.0)
                ],
              ),
              height: 200.0,
              width: 300.0,
              child: new Align(
                  alignment: Alignment.centerRight,
                  child: new Image.asset(
                      course.imagePath,
                      width: 150)
              ),
            ),
            new Align(
              alignment: Alignment.centerLeft,
              child: new Container(
                  padding: EdgeInsets.only(left:20),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(flex:4),
                      new Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        decoration: new BoxDecoration(
                            border: Border.all(width: 2, color: statusBorderColor),
                            color: statusColor,
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0) //                 <--- border radius here
                            ),
                        ),
                        child: new Text(
                          course.status,
                          style: new TextStyle(color: Colors.white, fontSize: 14),
                        )
                      ),
                      Spacer(flex:3),
                      new Text(
                        course.name,
                        style: new TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Spacer(flex:2),
                      new Text(
                        "4 Exercises | 5 weeks",
                        style: new TextStyle(color: Colors.white, fontSize: 12,  fontWeight: FontWeight.bold),
                      ),
                      Spacer(flex:4),
                    ],
                  )),
            )
          ],
        )
      ),
    );
  }
}


class AccessoriesItem extends StatelessWidget {
  final int index;

  AccessoriesItem(this.index, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = index == 0 ? const EdgeInsets.only(
        left: 20.0, right: 10.0, top: 4.0, bottom: 30.0) : const EdgeInsets
        .only(
        left: 10.0, right: 10.0, top: 4.0, bottom: 30.0);

    // return new GridTile(
    //   child: new Card(
    //       color: Colors.blue.shade200,
    //       child: new Center(
    //         child: new Text('tile $index'),
    //       )
    //   ),
    // );

    var accessories = context.select((AccessoriesNotifier cn) => cn.getByPosition(this.index));

    return new Padding(
      padding: padding,
      child: new InkWell(
          onTap: () {

          },
          child: new Stack(
            children: [
              new Container(
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(40.0),
                    color: accessories.color,
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black.withAlpha(70),
                          offset: const Offset(3.0, 10.0),
                          blurRadius: 15.0)
                    ],
                  ),
                  child:
                  new Align(
                    alignment: Alignment.centerLeft,
                    child: new Container(
                        padding: EdgeInsets.only(left:20),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Spacer(flex:1),
                            new Padding(
                              padding: EdgeInsets.only(top: 10, right: 15, left: 5),
                              child: new Align(
                                  alignment: Alignment.center,
                                  child: new Image.asset(
                                      accessories.imagePath,
                                      width: 80)
                              ),
                            ),
                            new Spacer(flex: 3),
                            new Padding(
                              padding: EdgeInsets.only(bottom: 10, left:10),
                              child: new Align(
                                  alignment: Alignment.center,
                                  child: new Text(
                                    accessories.name,
                                    style: new TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                              ),
                            ),
                            Spacer(flex:1),
                          ],
                        )),
                  )
              ),
            ],
          )
      ),
    );
  }
}

