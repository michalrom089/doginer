// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doginer/models/exercise.dart';

/// A proxy of the catalog of items the user can buy.
///
/// In a real app, this might be backed by a backend and cached on device.
/// In this sample app, the catalog is procedurally generated and infinite.
///
/// For simplicity, the catalog is expected to be immutable (no products are
/// expected to be added, removed or changed during the execution of the app).

final ACCESSORIES_COLLECTION_NAME = "accessories";

@immutable
class Accessories {
  final int id;
  final String name;
  final String imagePath;
  final Color color;

  Accessories(this.id, this.name, this.imagePath, String backgroundColor)
  // To make the sample app look nicer, each item is given one of the
  // Material Design primary colors.
      : color = Color(int.parse("FF" + backgroundColor, radix: 16));

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Accessories && other.id == id;
}

class AccessoriesNotifier extends ChangeNotifier {
  List<Accessories> _accessories = [];

  AccessoriesNotifier() { fetchData(); }

  void fetchData() async {
    List<Accessories> fetched = [];
    Query accQuery = FirebaseFirestore.instance.collection(ACCESSORIES_COLLECTION_NAME);

    var query = await accQuery
        .orderBy("ID")
        .get();

    await Future.forEach(query.docs, (element) async {
      var data = element.data();

      fetched.add(new Accessories(data["ID"], data["Name"], data["ImagePath"], data["BackgroundColor"]));
    });

    this._accessories = fetched;

    notifyListeners();
  }

  int getSize(){
    return this._accessories.length;
  }

  Accessories getByPosition(int id){
    return this._accessories[id % this._accessories.length];
  }
}
