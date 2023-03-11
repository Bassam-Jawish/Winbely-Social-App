import 'package:chat_app/bloc/add_post/add_post_bloc.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:chat_app/ui/components/components.dart';
import 'package:chat_app/ui/widgets/videoController.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

class AddScreen extends StatelessWidget {
  AddScreen({Key? key}) : super(key: key);

  var descController = TextEditingController();

  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocListener<AddPostBloc, AddPostState>(
      listener: (context, state) {
        if (state is AddPostSuccess) {
          showToast(text: 'Added Successfully', state: ToastState.success);
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBar(context),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04, vertical: height * 0.02),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          color: Colors.pink.withOpacity(0.1),
                          blurRadius: 5,
                        )
                      ],
                      color: Colors.white,
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      borderRadius: BorderRadius.circular(50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 0.03,
                          ),
                          BlocBuilder<AddPostBloc, AddPostState>(
                            builder: (context, state) {
                              return state is! AddPhoto
                                  ? Container(
                                      width: width * 0.8,
                                      height: height * 0.2,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: primaryColor,
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          splashColor: Colors.white,
                                          onTap: () {
                                            BlocProvider.of<AddPostBloc>(
                                                    context)
                                                .add(ImagePickerEvent(
                                                    context: context));
                                          },
                                          child: const Center(
                                            child: Text(
                                              '+ Add Photo/Video',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 35),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            BlocProvider.of<AddPostBloc>(
                                                    context)
                                                .add(ImagePickerEvent(
                                                    context: context));
                                          },
                                          child: Container(
                                            width: width * 0.3,
                                            height: height * 0.04,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                gradient: primaryGradient),
                                            child: const Center(
                                              child: Text(
                                                'Change',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Image.file(
                                          BlocProvider.of<AddPostBloc>(context)
                                              .file!,
                                          height: height * 0.4,
                                          fit: BoxFit.cover,
                                          width: width * 0.85,
                                          //image: const AssetImage('assets/images/n.jpg'),
                                        ),
                                        /*ChewieListItem(
                                      videoPlayerController:
                                          VideoPlayerController.file(
                                              state.file),
                                      ),*/
                                      ],
                                    );
                            },
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.11),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description:',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Form(
                                  key: formKey,
                                  child: defaulttextFormField(
                                      controller: descController,
                                      keyboardType: TextInputType.text,
                                      borderColor: primaryColor,
                                      maxLines: 6,
                                      cursorColor: primaryColor,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "It's empty";
                                        }
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  BlocBuilder<AddPostBloc, AddPostState>(
                    builder: (context, state) {
                      return ConditionalBuilder(
                        condition: state is! AddPostLoading,
                        builder: (context) => Container(
                            width: width * 0.3,
                            height: height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: primaryGradient,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                splashColor: Colors.white,
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    if (BlocProvider.of<AddPostBloc>(context)
                                            .file !=
                                        null) {
                                      BlocProvider.of<AddPostBloc>(context).add(
                                        UploadPostEvent(
                                            file: BlocProvider.of<AddPostBloc>(
                                                    context)
                                                .file!,
                                            desc: descController.text),
                                      );
                                      descController.clear();
                                      BlocProvider.of<AddPostBloc>(context)
                                          .file = null;
                                    } else {
                                      showToast(
                                          text: 'There is no image',
                                          state: ToastState.error);
                                    }
                                  }
                                },
                                child: const Center(
                                  child: Text(
                                    'Add Post',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            )),
                        fallback: (context) => Padding(
                          padding: EdgeInsets.only(top: height * 0.04),
                          child: const SpinKitCircle(
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
