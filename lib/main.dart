import 'package:flutter/material.dart';
import 'features/auth/view/login_view.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: const LoginView(),
    );
  }
}
 
// import 'package:appwrite/appwrite.dart';

// Client client = Client();
// client
//     .setEndpoint('http://localhost/v1')
//     .setProject('63e65f5b38caba16c84d')
//     .setSelfSigned(status: true); // For self signed certificates, only use for development

// => docker
// => appwrite
// => svg
// => export
// => feature-first approach
// => flutter_svg
