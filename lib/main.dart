import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socially/common/common.dart';
import 'package:socially/features/auth/controller/auth_controller.dart';
import 'package:socially/features/auth/view/login_view.dart';
import 'package:socially/features/home/view/home_view.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Socially',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return const HomeView();
              }
              return const LoginView();
            },
            error: (error, stackTrace) {
              return ErrorPage(
                error: error.toString(),
              );
            },
            loading: () => const LoadingPage(),
          ),
    );
  }
}

// flutter version 3.7.6
// => docker
// => appwrite
// => svg
// => exportzzoha
// => feature-first approach
// => flutter_svg
// => functional programming
// => typedef
// => riverpod
// => immutable
// => appwrite database
// => enums, extension
// => autodispose in appwrite
// TODO: pass ip address from mobile in place of local host or ***.***.*.*** static
// TODO: import '../../../models/notification_model.dart' as model; as keyword
