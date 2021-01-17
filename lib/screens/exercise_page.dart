import 'package:doginer/models/course.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doginer/models/app_user.dart';
import 'package:doginer/models/exercise.dart';
import 'package:doginer/common/theme.dart';
import 'package:lipsum/lipsum.dart' as lipsum;
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';



class ExercisePage extends StatefulWidget {
  Exercise exercise;

  ExercisePage({Key key, this.exercise}) : super(key: key);

  @override
  _ExercisePage createState() => _ExercisePage(exercise: exercise);
}


class _ExercisePage extends State<ExercisePage> {
  Exercise exercise;
  ButtonState stateTextWithIcon;

  _ExercisePage({this.exercise}){
    if(this.exercise.isCompleted){
      stateTextWithIcon=ButtonState.success;
    }else{
      stateTextWithIcon=ButtonState.idle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cn = Provider.of<CourseNotifier>(context);

    final model = Provider.of<CourseNotifier>(context, listen: true);
    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 120.0),
        Icon(
          Icons.pets,
          color: Colors.white,
          size: 40.0,
        ),
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 10.0),
        Text(
          exercise.name,
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  exercise.level,
                  style: TextStyle(color: Colors.white),
                )),
            Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(7.0),
                decoration: new BoxDecoration(
                    border: new Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(5.0)),
                child: new Text(
                  exercise.status,
                  style: TextStyle(color: Colors.white),
                ),
            )
          ],
        ),
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage('assets/course-${exercise.id % 3 +1}.jpg'),
                fit: BoxFit.cover,
              ),
            )
        ),
        Container(
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .5)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Text(
      lipsum.createParagraph(),
      style: TextStyle(fontSize: 18.0),
    );
    final readButton = ProgressButton.icon(iconedButtons: {
        ButtonState.idle:
        IconedButton(
            text: "Complete",
            icon: Icon(Icons.send,color: Colors.white),
            color: primaryColor),
        ButtonState.loading:
        IconedButton(
            text: "Loading",
            color: secondaryColor),
        ButtonState.fail:
        IconedButton(
            text: "Failed",
            icon: Icon(Icons.cancel,color: Colors.white),
            color: Colors.red.shade300),
        ButtonState.success:
        IconedButton(
            text: "Completed",
            icon: Icon(Icons.check_circle,color: Colors.white,),
            color: Colors.green.shade400)
      },
          onPressed: () {
            // AppUser().completeExercise(exercise);
            cn.completeExercise(exercise.id);
            ///Do something here
            setState(() {
              stateTextWithIcon = ButtonState.success;
            });
          },
          state: stateTextWithIcon);

    final bottomContent = Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Theme.of(context).primaryColor,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[
            bottomContentText
            ],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
      bottomNavigationBar: new BottomAppBar(
        child: Padding(
          padding: EdgeInsets.only(bottom:10),
          child: readButton,
        ),
      ),
    );
  }
}