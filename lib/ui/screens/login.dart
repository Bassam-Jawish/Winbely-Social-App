import 'package:chat_app/bloc/auth/auth_bloc.dart';
import 'package:chat_app/bloc/internet_connection/internet_bloc.dart';
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

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  var emailControllerLogin = TextEditingController();
  var passwordControllerLogin = TextEditingController();
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var emailFocusNode = FocusNode();
  var passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: primaryColor,
        systemNavigationBarColor: gradientEnd,
      ),
    );
    return BlocListener<InternetBloc, InternetState>(
  listener: (context, state) {



    if (state is NotConnectedState){
      buildNotConnectedDialog(context);
    }

    if (state is ConnectedState && BlocProvider.of<InternetBloc>(context).show == true){
      //Navigator.of(context).pushNamed('/');
      //Navigator.pop(context);
      //Navigator.pop(context);
      buildConnectedDialog(context);

    }

  },
  child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            showToast(text: 'Login Successfully', state: ToastState.success);
            CacheHelper.saveData(
              key: 'token',
              value: state.token,
            ).then((value) {
              token = state.token;
              Navigator.of(context).pushReplacementNamed('/home');
            });
          }
          if (state is LoginError) {
            //showToast(text: BlocProvider.of<AuthBloc>(context).LoginTextError!, state: ToastState.error);
            showToast(text: state.loginErrorMessage, state: ToastState.error);
          }
/*
          if (state is AuthNotConnected){
            buildNotConnectedDialog(context);

          }
          if (state is AuthConnected && BlocProvider.of<AuthBloc>(context).show==true){
            Navigator.pop(context);
            buildConnectedDialog(context);
          }
*/
        },
        child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
                appBar: null,
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.only(
                        top: height * 0.27,
                        left: width * 0.06,
                        right: width * 0.06),
                    decoration: const BoxDecoration(gradient: primaryGradient),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Log In.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 45.0,
                              ),
                            ),
                            Text(
                              "We missed you!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: height * 0.04),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                defaulttextFormField(
                                  focusNode: emailFocusNode,
                                  onFieldSubmitted: (val){
                                    FocusScope.of(context).requestFocus(passwordFocusNode);
                                  },
                                 // focusNode: ,
                                    controller: emailControllerLogin,
                                    keyboardType: TextInputType.emailAddress,
                                    labelText: 'Email Address',
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (!EmailValidator.validate(value!)) {
                                        return 'Please enter a valid Email';
                                      }
                                      return null;
                                    },
                                    borderColor: Colors.white,
                                    cursorColor: Colors.white),
                                defaulttextFormField(
                                  focusNode: passwordFocusNode,
                                    controller: passwordControllerLogin,
                                    keyboardType: TextInputType.visiblePassword,
                                    labelText: 'Password',
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your Password';
                                      }
                                      return null;
                                    },
                                    obscureText: true,
                                    borderColor: Colors.white,
                                    cursorColor: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return ConditionalBuilder(
                              condition: state is! LoginLoading,
                              builder: (context) => Container(
                                //margin: const EdgeInsets.only(top: 40.0),
                                margin: EdgeInsets.only(top: height * 0.05),
                                height: height*0.07,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  border: Border.all(color: Colors.white),
                                  color: Colors.white,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                      ),
                                      elevation: 5.0),
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (formKey.currentState!.validate()) {
                                      BlocProvider.of<AuthBloc>(context).add(
                                          LoginEvent(
                                              email: emailControllerLogin.text,
                                              password: passwordControllerLogin
                                                  .text));
                                    }
                                  },
                                  child: const Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20.0,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              fallback: (context) => Padding(
                                padding: EdgeInsets.only(top: height * 0.04),
                                child: const SpinKitCircle(
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          //padding: const EdgeInsets.only(top: 50.0),
                          padding: EdgeInsets.only(top: height * 0.05),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed('/reset_password');
                            },
                            child: const Center(
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          //padding: const EdgeInsets.only(top: 20.0),
                          padding: EdgeInsets.only(top: height * 0.03),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/register');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  'New User?',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  ' Create account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.238,
                        )
                      ],
                    ),
                  ),
                )))),
);
  }
}
