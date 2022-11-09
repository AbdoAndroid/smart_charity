import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog? progressDialog;
showProgress(BuildContext context, String message, bool isDismissible) async {
  progressDialog = ProgressDialog(context, type: ProgressDialogType.Download, isDismissible: isDismissible);
  progressDialog?.style(
      message: message,
      borderRadius: 10.0,
      backgroundColor: Colors.transparent,
      progressWidget: Container(
          padding: const EdgeInsets.all(8.0),
           child: const CircularProgressIndicator(
            backgroundColor: Colors.white,
          )),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: const TextStyle(color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600));
  await progressDialog?.show();
}

updateProgress(String message) {
  progressDialog?.update(message: message);
}

hideProgress() async {
  if (progressDialog != null) await progressDialog?.hide();
}