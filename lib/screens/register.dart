// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../model/response/custom-reponse.model.dart';
import '../services/auth/login.service.dart';
import '../services/users/create-user.service.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            padding: const EdgeInsets.only(left: 35, top: 20),
            child: const Text(
              "Crie uma Conta",
              style: TextStyle(color: Colors.white, fontSize: 33),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  right: 35,
                  left: 35,
                  top: MediaQuery.of(context).size.height * 0.27),
              child: Column(children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    hintText: 'Nome',
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    hintText: 'Nome de Usuário/Email',
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    hintText: 'Senha',
                    hintStyle: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Registrar-se',
                        style: TextStyle(
                          color: Colors.white,
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
                            EasyLoading.show(status: 'loading...');
                            bool isCreated = await registrar(
                                nameController.text,
                                usernameController.text,
                                passwordController.text);
                            EasyLoading.dismiss();

                            if (!isCreated) return;

                            Navigator.pushNamed(context, 'home');
                          },
                          icon: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ]),
                const SizedBox(
                  height: 40,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'login');
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Colors.white,
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

Future<bool> registrar(String name, String username, String password) async {
  EasyLoading.instance.toastPosition = EasyLoadingToastPosition.bottom;
  EasyLoading.instance.animationDuration = const Duration(milliseconds: 6000);

  if (name.isEmpty) {
    await EasyLoading.showToast('Campo Nome devem ser preenchido!');
    return false;
  }

  if (username.isEmpty) {
    await EasyLoading.showToast(
        'Campo Nome de Usuário/Email devem ser preenchido!');
    return false;
  }

  if (password.isEmpty) {
    await EasyLoading.showToast('Campo Senha devem ser preenchido!');
    return false;
  }

  CustomMessageResponse res =
      await CreateUserService.createUser(name, username, password);

  if (!res.success) {
    EasyLoading.showToast(res.message);
    return false;
  }

  CustomMessageResponse loginRes = await LoginService.login(username, password);

  if (!loginRes.success) {
    EasyLoading.showToast(res.message);
    return false;
  }

  return true;
}
