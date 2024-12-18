import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app/firebase/model/task.dart';
import 'package:to_do_app/firebase/model/user.dart';

class FireStoreHandler {
  static CollectionReference<User> getUserCollection() {
    var collection = FirebaseFirestore.instance
        .collection(User.collectionName)
        .withConverter(
      fromFirestore: (snapshot, options) {
        return User.fromFireStore(snapshot.data());
      },
      toFirestore: (user, options) {
        return user.toFireStore();
      },
    );
    return collection;
  }

  static Future<void> createUser(User user) {
    var collection = getUserCollection();
    var docRef = collection.doc(user.id);
    return docRef.set(user);
  }

  static CollectionReference<Task> getTasksCollection(String userId) {
    var collection = getUserCollection()
        .doc(userId)
        .collection(Task.collectionName)
        .withConverter(
      fromFirestore: (snapshot, options) {
        return Task.fromFireStore(snapshot.data());
      },
      toFirestore: (task, options) {
        return task.toFireStore();
      },
    );
    return collection;
  }

  static Future<void> createTask(String userId, Task task) {
    var collection = getTasksCollection(userId);
    var docRef = collection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<List<Task>> getTasks(String userId) async {
    var collection = getTasksCollection(userId);
    var querySnapShot = await collection.get();
    var queryList = querySnapShot.docs;
    var tasksList = queryList.map((doc) => doc.data()).toList();
    return tasksList;
  }

  static Stream<List<Task>> getTasksListen(
      String userId, DateTime selectedDate) async* {
    var newDate = Timestamp.fromDate(
      selectedDate.copyWith(
        hour: 0,
        microsecond: 0,
        millisecond: 0,
        second: 0,
        minute: 0,
      ),
    );
    var collection = getTasksCollection(userId).where(
      'date',
      isEqualTo: newDate,
    );
    var queryStream = collection.snapshots();
    var tasksStream = queryStream
        .map((event) => event.docs.map((doc) => doc.data()).toList());
    yield* tasksStream;
  }

  static Future<void> deleteTask(String userId, String taskId) {
    var collection = getTasksCollection(userId);
    return collection.doc(taskId).delete();
  }

  static Future<void> isDone(Task task, String uId) {
    var collection = getTasksCollection(uId);
    return collection.doc(task.id).update({
      'isDone': !task.isDone!,
    });
  }

  static Future<void> updateTask(Task task,String uId) {
    return getTasksCollection(uId).doc(task.id).update(
          task.toFireStore(),
        );
  }
}
