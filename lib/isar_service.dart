import 'package:isar/isar.dart';
import 'package:myapp/entities/course.dart';
import 'package:myapp/entities/student.dart';
import 'package:myapp/entities/teacher.dart';
import 'package:path_provider/path_provider.dart';





class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }
  Future<Isar> openDB() async {
      final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [CourseSchema, StudentSchema, TeacherSchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }
  Future<void> saveCourse(Course newCourse) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.courses.putSync(newCourse));
  }

  Future<void> saveStudent(Student newStudent) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.students.putSync(newStudent));
  }

  Future<void> saveTeacher(Teacher newTeacher) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.teachers.putSync(newTeacher));
  }

  Future<List<Course>> getAllCourses() async {
    final isar = await db;
    return await isar.courses.where().findAll();
  }

  Stream<List<Course>> listenToCourses() async* {
    final isar = await db;
    yield* isar.courses.where().watch(fireImmediately: true);
    
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<List<Student>> getStudentsFor(Course course) async {
    final isar = await db;
    return await isar.students
        .filter()
        .courses((q) => q.idEqualTo(course.id))
        .findAll();
  }

  Future<Teacher?> getTeacherFor(Course course) async {
    final isar = await db;

    final teacher = await isar.teachers
        .filter()
        .course((q) => q.idEqualTo(course.id))
        .findFirst();

    return teacher;
  }

    Future<List<Student>> getAllStudentsFromCourse(Course course) async {
    final isar = await db;
    return await isar.students
        .filter()
        .courses((q) => q.idEqualTo(course.id))
        .findAll();
  }


}
