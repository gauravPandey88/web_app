import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCycu2aT5wpDmTlWwyl7Gnv_4piOk6xki8",
            authDomain: "web-app-kmy3v3.firebaseapp.com",
            projectId: "web-app-kmy3v3",
            storageBucket: "web-app-kmy3v3.appspot.com",
            messagingSenderId: "494428248102",
            appId: "1:494428248102:web:6c01ef98409bb6cdbd6ee7"));
  } else {
    await Firebase.initializeApp();
  }
}
