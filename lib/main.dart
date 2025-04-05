import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'role_selection_page.dart';
import 'teacher_login_page.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding
  await Firebase.initializeApp(); // 🔥 Initialize Firebase

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(EduAllyApp());
}

class EduAllyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF5193B3),
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => RoleSelectionPage(),
        '/teacherLogin': (context) => TeacherLoginPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}






// import 'package:flutter/material.dart';
// import 'role_selection_page.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(EduAllyApp());
// }

// class EduAllyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Color(0xFF5193B3),
//         scaffoldBackgroundColor: Color(0xFFF5F7FA)
//       ),
//       home: RoleSelectionPage(),
//     );
//   }
// }
