// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:doginer/auth/sign_in.dart';
import 'package:flutter/material.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 24,
              ),
              RaisedButton(
                color: Colors.yellow,
                child: Text('Login'),
                onPressed: () {
                  signInWithGoogle().then((result) {
                    print(result);
                    if (result != null) {
                      Navigator.pushReplacementNamed(context, '/course_catalog');
                    }
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
