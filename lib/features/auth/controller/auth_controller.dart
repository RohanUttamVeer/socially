import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart' as model;
import 'package:socially/apis/auth_api.dart';
import 'package:socially/features/auth/view/login_view.dart';
import 'package:socially/features/home/view/home_view.dart';
import '../../../core/core.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
  );
});

final currentUserAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  AuthController({required AuthAPI authAPI})
      : _authAPI = authAPI,
        super(false);
  //state = isLoading

  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final response = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    response.fold(
      (l) => showSnackBar(
        context,
        l.message,
      ),
      (r) {
        showSnackBar(context, 'Account Created! Please Login');
        Navigator.push(context, LoginView.route());
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final response = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    response.fold(
      (l) => showSnackBar(
        context,
        l.message,
      ),
      (r) {
        Navigator.push(context, HomeView.route());
      },
    );
  }
}
