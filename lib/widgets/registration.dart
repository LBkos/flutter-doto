import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_manager/models/registration_model.dart';
import 'package:task_manager/providers/dio_provider.dart';
import 'package:task_manager/helps_view/custom_back_button.dart';
import '../helps_view/BorderedTextField.dart';

class Registration extends ConsumerWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text(
            'Регистрация',
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          leading: const CustomBackButton()),
      body: const RegistrationWidget(),
    );
  }
}

final userNameController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();

class RegistrationWidget extends ConsumerStatefulWidget {
  const RegistrationWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends ConsumerState<RegistrationWidget> {
  bool loading = false;
  final dio = DioProvider();
  Future<RegistrationModel> createUser() async {
    loading = true;
    setState(() {});
    final request = dio.init();
    request.options.headers['Content-Type'] = Headers.formUrlEncodedContentType;
    final response = await request.post(
      '/api/v1/register',
      data: {
        'name': userNameController.text,
        'email': emailController.text,
        'password': passwordController.text
      },
    );

    if (response.statusCode == 200) {
      loading = false;
      final _ = await dio.loginIn(
          passwordController.text,
          passwordController.text,
          // ignore: use_build_context_synchronously
          context);
      setState(() {});

      return RegistrationModel.fromJson(
          jsonDecode(response.data) as Map<String, dynamic>);
    } else {
      throw Exception('Failed registration');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(padding: EdgeInsets.fromLTRB(0, 52, 0, 12))
          Text(
            'Создать аккаунт',
            style: GoogleFonts.poppins(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            'Заполните поля для регистрации',
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF868D95)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 64, 0, 30),
            child: BorderedTextField(
                controller: userNameController,
                placeholder: 'Введите имя',
                password: false),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: BorderedTextField(
                controller: emailController,
                placeholder: 'Введите Email',
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
              padding: const EdgeInsets.fromLTRB(0, 28, 0, 16),
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
                    onPressed: () => {createUser()},
                    child: (loading)
                        ? const CircularProgressIndicator()
                        : Text('Регистрация',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                  ))),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Есть аккаунт?',
                style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF8D8D8D)),
              ),
              TextButton(
                  onPressed: () => {context.pop()},
                  child: Text(
                    'Войти',
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
