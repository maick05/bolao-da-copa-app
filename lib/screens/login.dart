// ignore_for_file: avoid_print

import 'package:bolao_da_copa/model/custom-reponse.model.dart';
import 'package:bolao_da_copa/services/auth/login.service.dart';
import 'package:flutter/material.dart';

import '../components/custom-tooltip.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final String _messageTooltip = "";

  @override
  Widget build(BuildContext context) {
    final GlobalKey<TooltipState> tooltipkeyEmail = GlobalKey<TooltipState>();
    final GlobalKey<TooltipState> tooltipkeyPassword =
        GlobalKey<TooltipState>();
    final GlobalKey<TooltipState> tooltipkeyInvalido =
        GlobalKey<TooltipState>();

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/login.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          CustomTooltip(
              stateKey: tooltipkeyEmail,
              message: "O campo Nome de Usuário ou Email deve ser preenchido!"),
          CustomTooltip(
              stateKey: tooltipkeyPassword,
              message: "O campo Senha deve ser preenchido!"),
          CustomTooltip(
              stateKey: tooltipkeyInvalido,
              message: "Usuário e/ou senha inválido(s)!"),
          Container(
            padding: const EdgeInsets.only(left: 35, top: 80),
            child: const Text(
              "Welcome\nBack",
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  right: 35,
                  left: 35,
                  top: MediaQuery.of(context).size.height * 0.5),
              child: Column(children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Email',
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
                    hintText: 'Password',
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
                      'Sign In',
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
                          bool isLoginValid = await logar(
                              usernameController.text,
                              passwordController.text, [
                            tooltipkeyEmail,
                            tooltipkeyPassword,
                            tooltipkeyInvalido
                          ]);
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
                          'Sign Up',
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
                          'Forgot Password',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Color(0xff4c505b),
                          ),
                        ),
                      ),
                    ]),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

Future<bool> logar(String username, String password,
    List<GlobalKey<TooltipState>> tooltipKeys) async {
  if (username.isEmpty) {
    tooltipKeys[0].currentState?.ensureTooltipVisible();
    return false;
  }

  if (password.isEmpty) {
    tooltipKeys[1].currentState?.ensureTooltipVisible();
    return false;
  }

  CustomMessageResponse loginRes = await LoginService.login(username, password);

  if (!loginRes.success) {
    tooltipKeys[2].currentState?.ensureTooltipVisible();
    return false;
  }

  return true;
}
