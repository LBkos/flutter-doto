import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/providers/navigation_service.dart';

const storage = FlutterSecureStorage();

Future<void> getToken() async {
  await Future.delayed(const Duration(seconds: 3));
  String? access = await storage.read(key: 'accessToken');
  if (access == null) {
    router.pushReplacement('/login');
  } else {
    router.pushReplacement('/home');
  }
}

class Start extends ConsumerStatefulWidget {
  const Start({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StartState createState() => _StartState();
}

class _StartState extends ConsumerState<Start> {
  final firstResponder = storage.read(key: 'firstResponser');
  bool first = false;
  @override
  void initState() {
    super.initState();

    // ignore: unrelated_type_equality_checks
    if (firstResponder.toString().isEmpty) {
      first = true;
    }

    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: Container(
      decoration: const BoxDecoration(
          gradient:
              LinearGradient(colors: [Color(0xFF6C5CFF), Color(0xFF6652FF)])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'images/start.image.png',
            scale: 0.9,
            alignment: Alignment.topCenter,
          ),
          Expanded(
              child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 63, 0, 16),
                    child: Text(
                      'Taska',
                      style: GoogleFonts.pollerOne(
                          fontSize: 46,
                          color: const Color(0xFF756EF3),
                          fontWeight: FontWeight.w400),
                    )),
                Text(
                  'Персональный\n таск-трекер',
                  style: GoogleFonts.poppins(
                    fontSize: 37,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2F394B),
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    'Порядок в делах – порядок в уме',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8D8D8D),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(40, 66, 40, 56),
                    child: first
                        ? Container(
                            height: 60,
                            width: double.infinity,
                            // padding: EdgeInsets.symmetric(horizontal: 40),
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF8B78FF),
                                  Color(0xFF5451D6)
                                ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(139, 120, 255, 0.6),
                                      spreadRadius: -9,
                                      blurRadius: 8,
                                      offset: Offset(0, 20))
                                ]),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(double.infinity, 60),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () => {
                                storage.write(
                                    key: 'firstResponser', value: 'false'),
                                context.pushReplacement('/login')
                              },
                              child: Text('Продолжить',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                            ))
                        : const CircularProgressIndicator(
                            color: Color(0xFF756EF3),
                          ))
              ],
            ),
          ))
        ],
      ),
    ));
  }
}
