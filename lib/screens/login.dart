// ignore_for_file: avoid_print

import 'package:bolao_da_copa/helper/loading.helper.dart';
import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';
import 'package:bolao_da_copa/screens/home.dart';
import 'package:bolao_da_copa/services/auth/login.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../helper/toast.helper.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return Navigator.canPop(context);
        },
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/login.png'),
                fit: BoxFit.cover),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(children: [
              Container(
                padding: const EdgeInsets.only(left: 35, top: 80),
                child: const Text(
                  "Bolão da Copa",
                  style: TextStyle(color: Colors.white, fontSize: 33),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(
                        right: 25,
                        left: 25,
                        top: MediaQuery.of(context).size.height * 0.5),
                    child: Expanded(
                      child: Column(children: [
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Nome de Usuário ou Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Senha',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Logar',
                              style: TextStyle(
                                color: Color(0xff4c505b),
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xff4c505b),
                              child: IconButton(
                                color: Colors.white,
                                onPressed: () async {
                                  usernameController.text =
                                      'maick@devseeder.com';
                                  passwordController.text = 'cosmos#1797';

                                  LoadingHelper.show();
                                  bool isLoginValid = await logar(
                                      usernameController.text,
                                      passwordController.text);
                                  LoadingHelper.hide();

                                  if (isLoginValid) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeTabBar(),
                                        ));
                                  }
                                },
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'register');
                                },
                                child: const Text(
                                  'Registrar-se',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                    color: Color(0xff4c505b),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Esqueci minha senha',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18,
                                    color: Color(0xff4c505b),
                                  ),
                                ),
                              ),
                            ]),
                      ]),
                    )),
              ),
            ]),
          ),
        ));
  }
}

Future<bool> logar(String username, String password) async {
  EasyLoading.instance.toastPosition = EasyLoadingToastPosition.bottom;
  // EasyLoading.instance.animationDuration = const Duration(milliseconds: 6000);

  if (username.isEmpty) {
    await ToastHelper.show(
        'Campo Nome de Usuário ou Email deve ser preenchido!');
    return false;
  }

  if (password.isEmpty) {
    await ToastHelper.show('Campo Senha deve ser preenchido!');
    return false;
  }

  CustomMessageResponse loginRes = await LoginService.login(username, password);

  if (!loginRes.success) {
    ToastHelper.showError(loginRes.message);
    return false;
  }
  return true;
}
