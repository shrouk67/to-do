import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/firebase/firestore_handler.dart';
import 'package:to_do_app/ui/home/tabs/task_item.dart';

class TaskTab extends StatelessWidget {
  DateTime selectedDate;

  TaskTab(this.selectedDate, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FireStoreHandler.getTasksListen(
          FirebaseAuth.instance.currentUser!.uid, selectedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Column(
            children: [
              Text(
                snapshot.error.toString(),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Try Again'),
              ),
            ],
          );
        }
        var tasksList = snapshot.data ?? [];
        return ListView.separated(
            itemBuilder: (context, index) => TaskItem(task: tasksList[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemCount: tasksList.length);
      },
    );
  }
}
