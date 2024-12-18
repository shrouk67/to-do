import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/style/app_colors.dart';

import '../../firebase/firestore_handler.dart';
import '../../firebase/model/task.dart';
import '../../style/dialog_utils.dart';
import '../../style/reusable_components/custom_text_field.dart';
import '../../style/validation.dart';

class EditTask extends StatefulWidget {
  static const String routeName = 'edit';

  const EditTask({super.key});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  Task? task;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (task == null) {
      task = ModalRoute.of(context)?.settings.arguments as Task;
      selectedDate = task!.date?.toDate();
      titleController.text = task!.title!;
      descriptionController.text = task!.description!;
    }
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              title: const Text('To Do List'),
            ),
          ),
          Positioned(
            top: kToolbarHeight + 80,
            left: 20,
            right: 20,
            child: Container(
              height: height * 0.7,
              padding: const EdgeInsets.all(27),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Edit Task",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: height * 0.05),
                    CustomTextField(
                      label: 'Enter Task Title',
                      keyword: TextInputType.text,
                      controller: titleController,
                      validator: (value) {
                        return Validation.fullNameValidator(
                            value, "Title Shouldn't be empty");
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextField(
                      label: 'Enter Task Description',
                      maxLines: null,
                      keyword: TextInputType.multiline,
                      controller: descriptionController,
                      validator: (value) {
                        return Validation.fullNameValidator(
                            value, "Description Shouldn't be empty");
                      },
                    ),
                    SizedBox(height: height * 0.02),
                    InkWell(
                      onTap: () {
                        showTaskDate();
                      },
                      child: Text(
                        selectedDate == null
                            ? 'Date'
                            : DateFormat.yMMMd().format(selectedDate!),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                      ),
                    ),
                    SizedBox(height: height * 0.2),
                    ElevatedButton(
                      onPressed: () {
                        updateTask();
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(width * 0.7, height * 0.06),
                        backgroundColor: AppColors.lightPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(height * 0.05),
                        ),
                      ),
                      child: const Text('Save Changes'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateTask() async {
    if (formKey.currentState!.validate()) {
      if (selectedDate != null) {
        DialogUtils.showLoading(context);
        task!.title = titleController.text;
        task!.description = descriptionController.text;
        task!.date = Timestamp.fromMillisecondsSinceEpoch(
          selectedDate!.millisecondsSinceEpoch,
        );

        await FireStoreHandler.updateTask(
          task!,
          FirebaseAuth.instance.currentUser!.uid,
        );
        Navigator.pop(context);
        DialogUtils.showMessageDialog(context,
            message: 'Task Updated Successfully',
            positiveActionClick: (context) {
          Navigator.pop(context);
          Navigator.pop(context);
        }, positiveActionTitle: 'OK');
      } else {
        DialogUtils.showToast('Please choose task date');
      }
    }
  }

  showTaskDate() async {
    selectedDate = await showDatePicker(
      initialDate: selectedDate ?? DateTime.now(),
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );
    setState(() {});
  }
}
