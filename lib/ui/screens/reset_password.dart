import 'package:chat_app/bloc/auth/auth_bloc.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:chat_app/ui/components/components.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);

  var resetPasswordController = TextEditingController();

  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess){

        }
        if (state is ResetPasswordError){
          showToast(
              text: state.errorMessage, state: ToastState.error);
        }
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
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.044, vertical: height * 0.12),
              decoration: const BoxDecoration(gradient: primaryGradient),
              height: height,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  resetAppBar(context),
                  Container(
                    child: const Text(
                      "Reset Password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Form(
                      key: formKey,
                      child: defaulttextFormField(
                        obscureText: false,
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        borderColor: Colors.white,
                        cursorColor: Colors.white,
                        controller: resetPasswordController,
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ConditionalBuilder(
                        condition: state is! ResetPasswordLoading,
                        builder: (context) =>
                            Container(
                              margin: const EdgeInsets.only(top: 40.0),
                              height: 60.0,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                border: Border.all(color: Colors.white),
                                color: Colors.white,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                    ),
                                    elevation: 5.0),
                                onPressed: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  BlocProvider.of<AuthBloc>(context).add(
                                      RestPasswordEvent(email: resetPasswordController.text));
                                },
                                child: const Text(
                                  'RESET',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20.0,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                        fallback: (context) =>
                            Padding(
                              padding: EdgeInsets.only(
                                  top: height * 0.04),
                              child: const SpinKitCircle(
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/register');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Or',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            ' Create new account',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget resetAppBar(context) {
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
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

}
