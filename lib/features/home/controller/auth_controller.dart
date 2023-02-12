// import 'package:flutter/cupertino.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:socially/apis/auth_api.dart';
// import '../../../core/core.dart';

// final authControllerProvider =
//     StateNotifierProvider<AuthController, bool>((ref) {
//   return AuthController(
//     authAPI: ref.watch(authAPIProvider),
//   );
// });

// class AuthController extends StateNotifier<bool> {
//   final AuthAPI _authAPI;
//   AuthController({required AuthAPI authAPI})
//       : _authAPI = authAPI,
//         super(false);
//   //state = isLoading

//   void signUp({
//     required String email,
//     required String password,
//     required BuildContext context,
//   }) async {
//     state = true;
//     final response = await _authAPI.signUp(
//       email: email,
//       password: password,
//     );
//     state = false;
//     response.fold(
//         (l) => showSnackBar(
//               context,
//               l.message,
//             ),
//         (r) => print(r.email));
//   }
//   void login({
//     required String email,
//     required String password,
//     required BuildContext context,
//   }) async {
//     state = true;
//     final response = await _authAPI.login(
//       email: email,
//       password: password,
//     );
//     state = false;
//     response.fold(
//         (l) => showSnackBar(
//               context,
//               l.message,
//             ),
//         (r) => print(r.userId));
//   }
// }
