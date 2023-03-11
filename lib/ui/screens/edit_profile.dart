import 'package:chat_app/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:chat_app/ui/components/components.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Edit_Profile extends StatefulWidget {
  Edit_Profile({Key? key}) : super(key: key);

  static final formKey = GlobalKey<FormState>();

  @override
  State<Edit_Profile> createState() => _Edit_ProfileState();
}

class _Edit_ProfileState extends State<Edit_Profile> {
  var nameControllerEdit = TextEditingController();

  var phoneNumberControllerEdit = TextEditingController();

  var emailControllerEdit = TextEditingController();

  var addressControllerEdit = TextEditingController();

  var genderRadioBtnVal = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is UpdateStateSuccess) {
          showToast(text: 'Updated Successfully', state: ToastState.success);
        }
        if (state is UpdateStateError) {
          showToast(text: 'Cannot be Updated', state: ToastState.error);

        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: (){
            FocusManager.instance.primaryFocus
                ?.unfocus();
          },
          child: Scaffold(
            appBar: appBarBack(context),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.only(top: height * 0.05),
                child: Column(
                  children: [
                    Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Stack(alignment: Alignment.bottomRight, children: [
                      Container(
                          child: Container(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),
                            // splashColor: Colors.blue,
                            child: ClipOval(
                              child: state is AddPhoto
                                  ? Image.file(
                                      BlocProvider.of<EditProfileBloc>(context)
                                          .file!,
                                      height: height * 0.15,
                                      fit: BoxFit.cover,
                                      width: width * 0.32,
                                      //image: const AssetImage('assets/images/n.jpg'),
                                    )
                                  : Image.asset(
                                      'assets/images/user.png',
                                      height: height * 0.15,
                                      fit: BoxFit.cover,
                                      width: width * 0.32,
                                    ),
                            ),
                            onTap: () {
                              BlocProvider.of<EditProfileBloc>(context)
                                  .add(ImagePickerEvent(context: context));
                            },
                          ),
                        ),
                      )),
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<EditProfileBloc>(context)
                              .add(ImagePickerEvent(context: context));
                        },
                        icon: const CircleAvatar(
                          radius: 30.0,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 30,
                            color: Color.fromARGB(255, 67, 64, 64),
                          ),
                        ),
                      ),
                    ]),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: height * 0.04),
                            child: Form(
                              key: Edit_Profile.formKey,
                              child: Column(
                                children: [
                                  defaulttextFormField(
                                    controller: nameControllerEdit,
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
                                    controller: emailControllerEdit,
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
                                    controller: phoneNumberControllerEdit,
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
                                    controller: addressControllerEdit,
                                    keyboardType: TextInputType.text,
                                    labelText: 'Address',
                                    labelStyle:
                                        const TextStyle(color: Colors.black),
                                    prefixIcon: const Icon(Icons.place_outlined,
                                        color: Colors.grey),
                                    obscureText: false,
                                    borderColor: Colors.black,
                                    cursorColor: Colors.black,
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
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: height * 0.02),
                                    child: ConditionalBuilder(
                                      condition: state is! UpdateStateLoading,
                                      builder: (context) => Container(
                                        margin: EdgeInsets.only(
                                            top: height * 0.01,
                                            bottom: height * 0.02),
                                        height: height * 0.07,
                                        width: width,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          border: Border.all(color: Colors.white),
                                        ),
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                          color: primaryColor,
                                          elevation: 10.0,
                                          shadowColor: Colors.white70,
                                          child: MaterialButton(
                                            onPressed: () {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              if (Edit_Profile
                                                  .formKey.currentState!
                                                  .validate() && BlocProvider.of<EditProfileBloc>(context).file !=null) {
                                                BlocProvider.of<EditProfileBloc>(
                                                        context)
                                                    .add(UpdateProfileInfoEvent(
                                                        name: nameControllerEdit
                                                            .text,
                                                        email: emailControllerEdit
                                                            .text,
                                                        phoneNumber:
                                                            phoneNumberControllerEdit
                                                                .text,
                                                        address:
                                                            addressControllerEdit
                                                                .text,
                                                        gender:
                                                            genderRadioBtnVal));
                                              }
                                            },
                                            child: const Text(
                                              'UPDATE',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      fallback: (context) => Padding(
                                        padding:
                                            EdgeInsets.only(top: height * 0.04),
                                        child: const SpinKitCircle(
                                          color: Colors.black,
                                          size: 40,
                                        ),
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
