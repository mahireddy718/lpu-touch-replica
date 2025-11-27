import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(LpuTouchApp()); // removed const
}

class LpuTouchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LPU Touch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      routes: {
        '/login': (context) => LoginScreen(),       // removed const
        '/dashboard': (context) => DashboardScreen(), // removed const
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.hasData ? DashboardScreen() : LoginScreen(); // removed const
        },
      ),
    );
  }
}
