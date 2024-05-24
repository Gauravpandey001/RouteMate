import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:routemate/dashboard.dart';
import 'package:routemate/splashscreen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBuYZfW2w_JFZ3-p1kJlOxUZd8rh20HLec',
      appId: '1:379646485157:android:a656b5f2bcdb841e45234c',
      messagingSenderId: '379646485157',
      projectId: 'routemate-a8f42',
      storageBucket: 'gs://routemate-a8f42.appspot.com',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Ensure the initial route is set to '/'
      routes: {
        '/': (context) =>  SplashScreen(),
        // DashboardScreen(userId: 'BYz6BM4toRRWhnwkMYVuwB77bvJ2')// Define your splash screen route
     },
    );
  }
}
