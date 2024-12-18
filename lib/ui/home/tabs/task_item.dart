import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_app/firebase/firestore_handler.dart';
import 'package:to_do_app/style/app_colors.dart';
import 'package:to_do_app/style/dialog_utils.dart';
import 'package:to_do_app/ui/edit_task/edit_task.dart';

import '../../../firebase/model/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: 0.4,
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                deleteTask(context);
              },
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
              backgroundColor: Colors.redAccent,
              icon: Icons.delete,
              label: 'delete',
            ),
            SlidableAction(
              onPressed: (context) {
                Navigator.pushNamed(
                  context,
                  EditTask.routeName,
                  arguments: task,
                );
              },
              backgroundColor: AppColors.lightPrimaryColor,
              icon: Icons.edit,
              label: 'edit',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 5,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: task.isDone!
                        ? AppColors.green
                        : AppColors.lightPrimaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: task.isDone!
                              ? Theme.of(context).textTheme.bodyLarge
                              : Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          task.description ?? "",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                task.isDone!
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextButton(
                          onPressed: () {
                            FireStoreHandler.isDone(
                                task, FirebaseAuth.instance.currentUser!.uid);
                          },
                          child: Text(
                            'Done!',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightPrimaryColor,
                        ),
                        onPressed: () {
                          FireStoreHandler.isDone(
                              task, FirebaseAuth.instance.currentUser!.uid);
                        },
                        child: const Icon(
                          Icons.check,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  deleteTask(BuildContext context) async {
    DialogUtils.showMessageDialog(
      context,
      message: 'Are you sure you want to delete this task ?',
      positiveActionTitle: 'YES',
      positiveActionClick: (context) async {
        DialogUtils.showLoading(context);
        await FireStoreHandler.deleteTask(
            FirebaseAuth.instance.currentUser!.uid, task.id ?? '');
        Navigator.pop(context);
        Navigator.pop(context);
        DialogUtils.showToast('This Task Deleted');
      },
      negativeActionClick: (context) {
        Navigator.pop(context);
      },
      negativeActionTitle: 'No',
    );
  }
}
