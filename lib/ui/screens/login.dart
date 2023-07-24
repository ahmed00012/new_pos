import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/colors.dart';
import 'package:shormeh_pos_new_28_11_2022/constants/prefs_utils.dart';
import 'package:shormeh_pos_new_28_11_2022/data_controller/auth_controller.dart';
import '../widgets/custom_progress_indicator.dart';
import 'cash_login.dart';
import 'home/home_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey _formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    if (getUserToken() != '') {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => Home()), (route) => false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer(builder: (context, ref, child) {
      final viewModel = ref.watch(financeFuture);
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Lottie.asset(
                          'assets/images/lf20_nyostiev.json',
                          height: size.height * 0.4,
                        ),
                        Card(
                          elevation: 3,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Constants.mainColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              children: [
                                Container(
                                  width: size.width * 0.6,
                                  child: TextFormField(
                                    controller: emailController,
                                    cursorColor: Constants.mainColor,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Constants.mainColor,
                                      ),
                                      suffixIcon:emailController.text.isEmpty
                                              ? const SizedBox()
                                              : GestureDetector(
                                                  onTap: () {
                                                    emailController.clear();
                                                  },
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Constants.mainColor,
                                                  )),
                                      hintText: 'email'.tr(),
                                      label: Text(
                                        'email'.tr(),
                                        style: TextStyle(
                                            color: Constants.mainColor),
                                      ),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Constants.mainColor)),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Constants.mainColor),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'emailRequired'.tr();
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: size.width * 0.6,
                                  child: TextFormField(
                                    obscureText: viewModel.isVisible,
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          viewModel.seePassword();
                                        },
                                        child: Icon(
                                          viewModel.isVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Constants.mainColor,
                                      ),
                                      hintText: 'password'.tr(),
                                      label: Text(
                                        'password'.tr(),
                                        style: TextStyle(
                                            color: Constants.mainColor),
                                      ),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: Constants.mainColor)),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        borderSide: BorderSide(
                                            width: 2,
                                            color: Constants.mainColor),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'passwordRequired'.tr();
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 90,
                                ),
                                viewModel.loading
                                    ? CustomProgressIndicator()
                                    : InkWell(
                                        onTap: () {
                                          String userToken = getUserToken();
                                          viewModel.login(
                                              email: emailController.text,
                                              password: passwordController.text,
                                              onSuccess: () {
                                            emailController.clear();
                                            passwordController.clear();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        userToken.isEmpty
                                                            ? Finance()
                                                            : Home()));
                                          });
                                        },
                                        child: Container(
                                          height: size.height * 0.07,
                                          width: size.width * 0.4,
                                          decoration: BoxDecoration(
                                            color: Constants.mainColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'login'.tr(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.height * 0.02),
                                            ),
                                          ),
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
