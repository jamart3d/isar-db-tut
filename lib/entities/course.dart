import 'package:isar/isar.dart';
import 'package:myapp/entities/student.dart';
import 'package:myapp/entities/teacher.dart';

part 'course.g.dart';

@Collection()
class Course {
  Id id = Isar.autoIncrement;
  late String title;

  @Backlink(to: "course")
  final teacher = IsarLink<Teacher>();

  @Backlink(to: "courses")
  final students = IsarLinks<Student>();
}
