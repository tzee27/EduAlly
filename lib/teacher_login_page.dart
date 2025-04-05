import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'forget_password_page.dart';
import 'home_screen.dart';

class TeacherLoginPage extends StatefulWidget {
  @override
  _TeacherLoginPageState createState() => _TeacherLoginPageState();
}

class _TeacherLoginPageState extends State<TeacherLoginPage> {
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Controllers for Email & Password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 🔹 Google Sign-In
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User canceled sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      _navigateToHome();
    } catch (e) {
      _showError('Google sign-in failed. Please try again.');
    }
  }

  // 🔹 Email & Password Login
  Future<void> _signInWithEmail() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _navigateToHome();
    } catch (e) {
      _showError('Invalid email or password. Please try again.');
    }
  }

  // 🔹 Navigation to Home Page
  void _navigateToHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  // 🔹 Show SnackBar for Errors
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 5),
            Text('Login to continue', style: TextStyle(fontSize: 16, color: Colors.black54)),
            SizedBox(height: 30),

            // 🔹 Email Input
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            // 🔹 Password Input
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),

            // 🔹 Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordPage()));
                },
                child: Text('Forgot Password?'),
              ),
            ),
            SizedBox(height: 20),

            // 🔹 Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5193B3),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _signInWithEmail, // Use Firebase Email Login
                child: Text('LOG IN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),

            Divider(),
            SizedBox(height: 10),
            Center(child: Text('or login with')),
            SizedBox(height: 10),

            // 🔹 Google Sign-In Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: Image.asset('assets/google_logo.png', height: 24), // Ensure this image exists
                label: Text('Sign in with Google'),
                onPressed: _signInWithGoogle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'forget_password_page.dart';

// class TeacherLoginPage extends StatefulWidget {
//   @override
//   _TeacherLoginPageState createState() => _TeacherLoginPageState();
// }

// class _TeacherLoginPageState extends State<TeacherLoginPage> {
//   bool _obscureText = true;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> _signInWithGoogle() async {
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//     if (googleUser == null) return; 
//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     await _auth.signInWithCredential(credential);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Welcome Back',
//               style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
//             ),
//             SizedBox(height: 5),
//             Text(
//               'Login to continue',
//               style: TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//             SizedBox(height: 30),
//             TextField(
//               decoration: InputDecoration(
//                 labelText: 'Email Address',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 15),
//             TextField(
//               obscureText: _obscureText,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
//                   onPressed: () {
//                     setState(() {
//                       _obscureText = !_obscureText;
//                     });
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ForgetPasswordPage()),
//                   );
//                 },
//                 child: Text('Forgot Password?'),
//               ),
//             ),
//             SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF5193B3),
//                   padding: EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 onPressed: () {},
//                 child: Text('LOG IN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
//               ),
//             ),
//             SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(vertical: 14),
//                   side: BorderSide(color: Colors.black),
//                 ),
//                 onPressed: _signInWithGoogle,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset('assets/google_logo.png', height: 24),
//                     SizedBox(width: 10),
//                     Text('Sign in with Google', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
