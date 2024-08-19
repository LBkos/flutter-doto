import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/providers/dio_provider.dart';
import '../helps_view/BorderedTextField.dart';

class Login extends ConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Вход',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      body: const LoginWidget(),
    );
  }
}

final dio = DioProvider();
final loginController = TextEditingController();
final passwordController = TextEditingController();

class LoginWidget extends ConsumerStatefulWidget {
  const LoginWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<LoginWidget> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(padding: EdgeInsets.fromLTRB(0, 52, 0, 12))
          Text(
            'Добро пожаловать',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Введите E-mail и пароль для входа',
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF868D95)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 64, 0, 30),
            child: BorderedTextField(
                controller: loginController,
                placeholder: 'Введитe Email',
                password: false),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: BorderedTextField(
                controller: passwordController,
                placeholder: 'Введите пароль',
                password: true),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 28, 0, 28),
              child: Container(
                  height: 48,
                  width: double.infinity,
                  // padding: EdgeInsets.symmetric(horizontal: 40),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF8B78FF), Color(0xFF5451D6)]),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(139, 120, 255, 0.6),
                            spreadRadius: -9,
                            blurRadius: 8,
                            offset: Offset(0, 20))
                      ]),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.infinity, 48),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () => {
                      setState(() {
                        loading = true;
                      }),
                      dio.loginIn(loginController.text, passwordController.text,
                          context)
                    },
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Color(0xFFFFFFFF),
                          )
                        : Text('Вход',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                  ))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Нет аккаунта?',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8D8D8D)),
              ),
              TextButton(
                  onPressed: () => {context.push('/registration')},
                  child: Text(
                    'Зарегистрироваться',
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF756EF3)),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
