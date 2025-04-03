import 'package:flutter/material.dart';
import 'role_selection_page.dart';

void main() async {
  runApp(EduAllyApp());
}

class EduAllyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF5193B3),
        scaffoldBackgroundColor: Color(0xFFF5F7FA)
      ),
      home: RoleSelectionPage(),
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
