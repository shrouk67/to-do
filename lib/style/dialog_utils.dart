import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogUtils {
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  static void showMessageDialog(
    BuildContext context, {
    required String message,
    String? positiveActionTitle,
    void Function(BuildContext context)? positiveActionClick,
    String? negativeActionTitle,
    void Function(BuildContext context)? negativeActionClick,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          if (positiveActionTitle != null)
            TextButton(
              onPressed: (){
                positiveActionClick!(context);
              },
              child: Text(positiveActionTitle),
            ),
          if (negativeActionTitle != null)
            TextButton(
              onPressed: (){
                negativeActionClick!(context);
              },
              child: Text(negativeActionTitle),
            ),
        ],
      ),
    );
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
