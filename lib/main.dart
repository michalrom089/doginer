// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:doginer/common/theme.dart';
import 'package:doginer/models/course.dart';
import 'package:doginer/models/accessories.dart';
import 'package:doginer/screens/main_page.dart';
import 'package:doginer/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();


    // Using MultiProvider is convenient when providing multiple objects.

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CourseNotifier>(create: (_) => CourseNotifier()),
        ChangeNotifierProvider<AccessoriesNotifier>(create: (_) => AccessoriesNotifier()),
      ],
      child: MaterialApp(
        title: 'Doginer',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomePage(),
          '/main_page': (context) => MainPage()
        },
      ),
    );
  }
}
