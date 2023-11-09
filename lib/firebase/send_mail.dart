import 'package:cloud_functions/cloud_functions.dart';

void sendEmail(String ownerEmail, String message) async {
  await FirebaseFunctions.instance.httpsCallable('sendEmail').call({
    'email': ownerEmail,
    'message': message,
  });
}
