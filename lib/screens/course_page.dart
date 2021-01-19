import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doginer/models/course.dart';
import 'package:doginer/models/exercise.dart';
import 'package:doginer/screens/exercise_page.dart';
import 'package:doginer/common/theme.dart';

class CoursePage extends StatelessWidget {
  final Course course;

  CoursePage({Key key, @required this.course}): super(key:key);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery
        .of(context)
        .size
        .width;
    final _height = MediaQuery
        .of(context)
        .size
        .height;

    var body = new Scaffold(
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
        child:CustomScrollView(
          slivers: <Widget>[
            // Add the app bar to the CustomScrollView.
            SliverAppBar(

              iconTheme: IconThemeData(
                color: Colors.white, //change your color here
              ),
              // Provide a standard title.
              title: Text(
                  course.name,
                  style: TextStyle(color: Colors.white)),
              // Allows the user to reveal the app bar if they begin scrolling
              // back up the list of items.
              floating: true,
              backgroundColor: Colors.transparent,
            ),
            // Next, create a SliverList
            _ExerciseModule(this.course.id),
          ],
        ),
      )
    );

    return body;
  }
}

class _ExerciseModule extends StatelessWidget {
  final int courseId;

  _ExerciseModule(this.courseId);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;


    var c = Provider.of<CourseNotifier>(context, listen: true);

    return new SliverPadding(
        padding: EdgeInsets.only(top:10),
        sliver: new SliverGrid(
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            delegate: SliverChildBuilderDelegate(
                  (context, index) => ExerciseItem(index, index+c.getByPosition(courseId).exercises[0].id),
                childCount: c.getByPosition(courseId).exercises.length,
            ),
          )
    );
  }
}

class ExerciseItem extends StatelessWidget {
  final int index;
  final int exerciseId;

  ExerciseItem(this.index, this.exerciseId, {Key key}) : super(key: key);

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
    var exercise = context.select((CourseNotifier cn) => cn.getExerciseById(exerciseId));

    return new Padding(
      padding: padding,
      child: new InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExercisePage(exercise: exercise),
                ));
          },
          child: new Stack(
            children: [
              new Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(40.0),
                  color: exercise.color,
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.black.withAlpha(70),
                        offset: const Offset(3.0, 10.0),
                        blurRadius: 15.0)
                  ],
                ),
                child: new Padding(
                  padding: EdgeInsets.only(top: 30, right: 10, left: 55),
                  child: new Align(
                      alignment: Alignment.topRight,
                      child: new Image.asset(
                          exercise.imagePath,
                          width: 100)
                  ),
                )
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
                          padding: const EdgeInsets.all(7.0),
                          decoration: new BoxDecoration(
                            border: new Border.all(color: exercise.isCompleted ? Colors.green.withOpacity(0.8) : Colors.white),
                            borderRadius: BorderRadius.circular(5.0),
                            color: exercise.isCompleted ? Colors.green.withOpacity(0.8) : Colors.transparent
                          ),
                          child: new Text(
                            exercise.status,
                            style: TextStyle(color: Colors.white),
                            ),
                        ),
                        Spacer(flex:3),
                        new Text(
                          exercise.name,
                          style: new TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer(flex:2),
                        new Text(
                          "${exercise.level}",
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

