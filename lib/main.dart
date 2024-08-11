import 'package:flutter/material.dart';
import 'package:myapp/course_detail_page.dart';
import 'package:myapp/course_modal.dart';
import 'package:myapp/entities/course.dart';
import 'package:myapp/isar_service.dart';
import 'package:myapp/student_modal.dart';
import 'package:myapp/teacher_modal.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teacher Database',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final service = IsarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isar DB Tutorial'), actions: [
        IconButton(
          onPressed: () => service.cleanDb(),
          icon: const Icon(Icons.delete),
        )
      ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<List<Course>>(
                stream: service.listenToCourses(),
                builder: (context, snapshot) => GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  scrollDirection: Axis.horizontal,
                  children: snapshot.hasData
                      ? snapshot.data!.map((course) {
                          return ElevatedButton(
                            onPressed: () async {
                              CourseDetailPage.navigate(
                                  context, course, service);
                              print("Course clicked");
                              print(course.title);
                              print(course.id);
                              // print(service.getAllStudentsFromCourse(course));
                              final studentsFuture =
                                  service.getAllStudentsFromCourse(
                                      course); // Get the Future

                              // Use await to wait for the Future to complete and get the result
                              final students = await studentsFuture;

                              for (var student in students) {
                                print(student.name);
                              }

                              //print(course.students);
                             //print(course.teacher);
                              final teacherFuture =
                                  service.getTeacherFor(course);
                              final teacherF = await teacherFuture;
                              print(teacherF?.name);
                              //print(course.students.first.name);
                              print(
                                  course.students.map((e) => e.name).toList());
                            },
                            child: Text(course.title),
                          );
                        }).toList()
                      : [],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    print(context);
                    return CourseModal(service);
                  });
            },
            child: const Text("Add Course"),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return StudentModal(service);
                  });
            },
            child: const Text("Add Student"),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return TeacherModal(service);
                  });
            },
            child: const Text("Add Teacher"),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
