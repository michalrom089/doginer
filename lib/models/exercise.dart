// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:doginer/common/theme.dart';

/// A proxy of the catalog of items the user can buy.
///
/// In a real app, this might be backed by a backend and cached on device.
/// In this sample app, the catalog is procedurally generated and infinite.
///
/// For simplicity, the catalog is expected to be immutable (no products are
/// expected to be added, removed or changed during the execution of the app).


class Exercise {
  final int id;
  final String name;
  final String level;
  final Color color;
  final String imagePath;
  final String description;
  String status;
  bool isCompleted;

  Exercise(this.id, this.name, this.level, this.description, this.imagePath, [this.isCompleted = false]):
        color = Color(int.parse("FF" + exerciseColors[id % exerciseColors.length], radix: 16)){
    if(isCompleted){
      this.status="Completed";
    }else{
      this.status="New";
    }
  }

  @override
  int get hashCode => id;

  void complete(){
    this.status = "Completed";
    this.isCompleted = true;
  }

}
