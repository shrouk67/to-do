import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/firebase/firestore_handler.dart';
import 'package:to_do_app/firebase/model/task.dart';
import 'package:to_do_app/style/dialog_utils.dart';
import 'package:to_do_app/style/reusable_components/custom_text_field.dart';
import 'package:to_do_app/style/validation.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 22,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Add New Task",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            CustomTextField(
              label: 'Enter Task Title',
              keyword: TextInputType.text,
              controller: titleController,
              validator: (value) {
                return Validation.fullNameValidator(
                    value, "Title Shouldn't be empty");
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
            CustomTextField(
              label: 'Enter Task Description',
              maxLines: null,
              keyword: TextInputType.multiline,
              controller: descriptionController,
              validator: (value) {
                return Validation.fullNameValidator(
                    value, "description Shouldn't be empty");
              },
            ),
            SizedBox(
              height: height * 0.02,
            ),
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
            SizedBox(
              height: height * 0.05,
            ),
            ElevatedButton(
              onPressed: () {
                addNewTask();
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  DateTime? selectedDate;

  addNewTask() async {
    if (formKey.currentState!.validate()) {
      if (selectedDate != null) {
        DialogUtils.showLoading(context);
        await FireStoreHandler.createTask(
          FirebaseAuth.instance.currentUser!.uid,
          Task(
            title: titleController.text,
            description: descriptionController.text,
            date: Timestamp.fromMillisecondsSinceEpoch(
              selectedDate!.millisecondsSinceEpoch,
            ),
          ),
        );
        Navigator.pop(context);
        DialogUtils.showMessageDialog(context, message: 'Task Add Successfully',
            positiveActionClick: (context) {
          Navigator.pop(context);
        }, positiveActionTitle: 'OK');
      } else {
        DialogUtils.showToast('Please choose task date');
      }
    }
  }

  showTaskDate() async {
    selectedDate = await showDatePicker(
      initialDate: selectedDate,
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );
    setState(() {});
  }
}
