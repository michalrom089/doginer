// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doginer/models/exercise.dart';
import 'package:doginer/models/app_user.dart';

/// A proxy of the catalog of items the user can buy.
///
/// In a real app, this might be backed by a backend and cached on device.
/// In this sample app, the catalog is procedurally generated and infinite.
///
/// For simplicity, the catalog is expected to be immutable (no products are
/// expected to be added, removed or changed during the execution of the app).

final COURSES_COLLECTION_NAME = "courses";
final EXERCISES_COLLECTION_NAME = "exercises";

class Course {
  final int id;
  final String name;
  final String imageName;
  final String description;
  final String imagePath;
  String status;
  final Color color;
  final int price = 42;
  final List<Exercise> exercises;

  Course(this.id, this.name, this.imageName, this.description, this.imagePath, this.exercises, String backgroundColor, this.status)
      // To make the sample app look nicer, each item is given one of the
      // Material Design primary colors.
      : color = Color(int.parse("FF" + backgroundColor, radix: 16));

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Course && other.id == id;
}

class CourseNotifier extends ChangeNotifier {
  List<Course> _courses = [];

  List<Course> plans() => this._courses;

  CourseNotifier() {
    print("Notifier");
    fetchData();
  }

  void fetchData() async {
    List<Course> coursesFetched = [];
    List<int> completedExercises = await AppUser().getCompletedExercises();
    Query courseQuery = FirebaseFirestore.instance.collection(COURSES_COLLECTION_NAME);
    Query exerciseQuery = FirebaseFirestore.instance.collection(EXERCISES_COLLECTION_NAME);

    var query = await courseQuery
        .orderBy("ID")
        .get();

    await Future.forEach(query.docs, (element) async {
      var exercises = new List<Exercise>();
      var courseData = element.data();

      var execQuery = await exerciseQuery
          .orderBy("ID")
          .get();
      execQuery.docs.forEach((element) {
          var exerciseData = element.data();
          if(courseData["exercises"].cast<int>().contains(exerciseData["ID"])){
            exercises.add(new Exercise(exerciseData["ID"], exerciseData["Name"], exerciseData["Level"], exerciseData["Description"], exerciseData["ImagePath"]));
          }
      });
      var status = "New";
      coursesFetched.add(new Course(courseData["ID"], courseData["Name"], courseData["ImageName"], courseData["Description"], courseData["ImagePath"], exercises, courseData["BackgroundColor"], status));
    });

    this._courses = coursesFetched;
    completedExercises.forEach((element) { completeExercise(element);});

    print(this._courses.length);
    notifyListeners();
  }

  int getSize(){
    return this._courses.length;
  }

  Course getByPosition(int id){
    return this._courses[id % this._courses.length];
  }

  List<Exercise> getAllExercises(){
    return this._courses.map((e) => e.exercises).expand((i) => i).toList();
  }

  void completeExercise(int id){

    for(var c in _courses){
      for(var e in c.exercises){
        if(e.id == id){
          e.complete();
          AppUser().completeExercise(e.id);
        }
      }

      if(c.exercises.every((element) => element.isCompleted)){
        c.status = "Completed";
      }else if(c.exercises.any((element) => element.isCompleted)){
        c.status = "In progress";
      }
    }

    notifyListeners();
  }

  Exercise getExerciseById(int id){
    var exercises = getAllExercises();
    for(var e in exercises){
      if(e.id == id){
        return e;
      }
    }

    return null;
  }
}
