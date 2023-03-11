import 'dart:io';

import 'package:chat_app/bloc/auth/auth_bloc.dart';
import 'package:chat_app/bloc/internet_connection/internet_bloc.dart';
import 'package:chat_app/cache/cache_helper.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:chat_app/ui/components/components.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameControllerRegister = TextEditingController();

  var phoneNumberControllerRegister = TextEditingController();

  var emailControllerRegister = TextEditingController();

  var passwordControllerRegister = TextEditingController();

  static final formKey = GlobalKey<FormState>();

  var genderRadioBtnVal = 0;



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        systemNavigationBarColor: Colors.white70,
      ),
    );
    return BlocListener<InternetBloc, InternetState>(
      listener: (context, state) {

          if (state is NotConnectedState) {
            buildNotConnectedDialog(context);
          }

          if (state is ConnectedState &&
              BlocProvider.of<InternetBloc>(context).show == true) {
            buildConnectedDialog(context);
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            showToast(
                text: 'Registered Successfully', state: ToastState.success);
            CacheHelper.saveData(
              key: 'token',
              value: state.token,
            ).then((value) {
              token = state.token;
              Navigator.of(context).pushReplacementNamed('/home');
            });
          }
          if (state is RegisterError) {
            showToast(
                text: state.registerErrorMessage, state: ToastState.error);
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: null,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.only(top: height * 0.05),
                  child: Column(
                    children: [
                      registerAppBar(context),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Tell us about you.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 40.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: height * 0.04),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    defaulttextFormField(
                                      controller: nameControllerRegister,
                                      keyboardType: TextInputType.name,
                                      labelText: 'Name',
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                      prefixIcon: const Icon(
                                        Icons.person_outline_outlined,
                                        color: Colors.grey,
                                      ),
                                      borderColor: Colors.black,
                                      cursorColor: Colors.black,
                                      maxLength: 25,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: height * 0.04,
                                    ),
                                    defaulttextFormField(
                                      controller: emailControllerRegister,
                                      keyboardType: TextInputType.emailAddress,
                                      labelText: 'Email Address',
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                      prefixIcon: const Icon(
                                        Icons.email_outlined,
                                        color: Colors.grey,
                                      ),
                                      borderColor: Colors.black,
                                      cursorColor: Colors.black,
                                      validator: (value) {
                                        if (!EmailValidator.validate(value!)) {
                                          return 'Please enter a valid Email';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: height * 0.04,
                                    ),
                                    defaulttextFormField(
                                      controller: phoneNumberControllerRegister,
                                      keyboardType: TextInputType.number,
                                      labelText: 'Phone Number',
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                      prefixIcon: const Icon(
                                          Icons.phone_android_outlined,
                                          color: Colors.grey),
                                      borderColor: Colors.black,
                                      cursorColor: Colors.black,
                                      maxLength: 10,
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your number';
                                        }
                                        if (RegExp(
                                                r"[!@#<>?':_`~ N؛،؟.,/;[\]\\|=+)(*&-]")
                                            .hasMatch(value)) {
                                          return 'Wrong number';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: height * 0.04,
                                    ),
                                    defaulttextFormField(
                                      controller: passwordControllerRegister,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      labelText: 'Password',
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                      prefixIcon: const Icon(Icons.lock_outline,
                                          color: Colors.grey),
                                      obscureText: true,
                                      borderColor: Colors.black,
                                      cursorColor: Colors.black,
                                      maxLength: 50,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "This field shouldn't be empty";
                                        }
                                        if (value.length < 6) {
                                          return 'The password should be six characters or above';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: height * 0.04,
                                    ),
                                    Row(
                                      children: [
                                        Radio(
                                          activeColor: primaryColor,
                                          value: 0,
                                          groupValue: genderRadioBtnVal,
                                          onChanged: (value) {
                                            setState(() {
                                              genderRadioBtnVal = value!;
                                            });
                                          },
                                        ),
                                        const Text("Male"),
                                        Radio(
                                          activeColor: primaryColor,
                                          value: 1,
                                          groupValue: genderRadioBtnVal,
                                          onChanged: (value) {
                                            setState(() {
                                              genderRadioBtnVal = value!;
                                            });
                                          },
                                        ),
                                        const Text("Female"),
                                        Radio(
                                          activeColor: primaryColor,
                                          value: 2,
                                          groupValue: genderRadioBtnVal,
                                          onChanged: (value) {
                                            setState(() {
                                              genderRadioBtnVal = value!;
                                            });
                                          },
                                        ),
                                        const Text("Other"),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: height * 0.02),
                                      child: BlocBuilder<AuthBloc, AuthState>(
                                        builder: (context, state) {
                                          return ConditionalBuilder(
                                            condition:
                                                state is! RegisterLoading,
                                            builder: (context) => Container(
                                              margin: EdgeInsets.only(
                                                  top: height * 0.01,
                                                  bottom: height * 0.02),
                                              height: height * 0.07,
                                              width: width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                border: Border.all(
                                                    color: Colors.white),
                                              ),
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                color: primaryColor,
                                                elevation: 10.0,
                                                shadowColor: Colors.white70,
                                                child: MaterialButton(
                                                  onPressed: ()  {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();
                                                    if (formKey.currentState!
                                                        .validate()) {

                                                      BlocProvider
                                                              .of<AuthBloc>(
                                                                  context)
                                                          .add(RegisterEvent(
                                                              name:
                                                                  nameControllerRegister
                                                                      .text,
                                                              email:
                                                                  emailControllerRegister
                                                                      .text,
                                                              phoneNumber:
                                                                  phoneNumberControllerRegister
                                                                      .text,
                                                              password:
                                                                  passwordControllerRegister
                                                                      .text,
                                                              gender:
                                                                  genderRadioBtnVal));
                                                    }
                                                  },
                                                  child: const Text(
                                                    'CREATE ACCOUNT',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 20.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            fallback: (context) => Padding(
                                              padding: EdgeInsets.only(
                                                  top: height * 0.04),
                                              child: const SpinKitCircle(
                                                color: Colors.black,
                                                size: 40,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget registerAppBar(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
