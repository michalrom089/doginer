import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doginer/models/exercise.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final USERS_COLLECTION_NAME = "users";


class AppUser {
    User user;
    DocumentReference query;
    String completedExercisesKey = "completedExercises";

    AppUser(){

      user = FirebaseAuth.instance.currentUser;
      query = FirebaseFirestore.instance.collection(USERS_COLLECTION_NAME).doc(user.uid);
    }

    void completeExercise(int exerciseId) async {
      var completedExercises = await getCompletedExercises();

      if(!completedExercises.contains(exerciseId)){
        print("set");
        completedExercises.add(exerciseId);
        await query.set({
          completedExercisesKey: completedExercises
        });
      }
    }

    Future<List<int>> getCompletedExercises() async{
      if((await query.get()).exists){
        return await query.get().then((value) =>
            List.from(value.data()[completedExercisesKey])
        );
      }else{
        return new List<int>();
      }
    }
}