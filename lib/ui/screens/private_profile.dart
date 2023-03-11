import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/bloc/auth/auth_bloc.dart';
import 'package:chat_app/bloc/priavte_profile/private_profile_bloc.dart';
import 'package:chat_app/cache/cache_helper.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:chat_app/ui/components/components.dart';
import 'package:chat_app/ui/widgets/videoController.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

class PrivateProfile extends StatelessWidget {
  const PrivateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SignOutSuccess) {
          showToast(
            text: 'SignOut Successfully',
            state: ToastState.success,
          );
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              statusBarColor: primaryColor,
              systemNavigationBarColor: gradientEnd,
            ),
          );
          CacheHelper.signOut(key: 'token').then((value) {
            if (value) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false);
            }
          });
        }
      },
      child: Scaffold(
        appBar: appBar(context),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(children: [
            Container(
              decoration: const BoxDecoration(
                gradient: primaryGradient,
              ),
              child: const Image(image: AssetImage('assets/images/Po.png')),
            ),
            BlocBuilder<PrivateProfileBloc, PrivateProfileState>(
              builder: (context, state) {
                return ConditionalBuilder(
                    condition: state is PersonalInfoSuccess,
                    builder: (context) => StreamBuilder(
                        stream:
                            state is PersonalInfoSuccess ? state.stream : null,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Padding(
                              padding: EdgeInsets.only(top: height * 0.3),
                              child: const SpinKitCircle(
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          } else {
                            var profileUrl = snapshot.data!['profileUrl'];
                            var name = snapshot.data!['name'];
                            var address = snapshot.data!['address'];
                            var postsNumber = snapshot.data!['postsNumber'];
                            var followers = snapshot.data!['followers'];
                            var following = snapshot.data!['following'];
                            Map <String,dynamic> posts = snapshot.data!['posts'];

                            var values = posts.values.toList();

                            return Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.04),
                              child: Column(children: [
                                SizedBox(height: height * 0.14),
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.centerRight,
                                  children: [
                                    CircleAvatar(
                                      maxRadius: 120,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: profileUrl,
                                          placeholder: (context, url) =>
                                              const SpinKitCircle(
                                            color: Colors.black,
                                            size: 40,
                                          ),
                                          height: height * 0.3,
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                          //image: NetworkImage(postUrl),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.25,
                                      height: height * 0.04,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed('/edit_profile');
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                        ),
                                        label: Text(
                                          'EDIT PROFILE',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  ?.color),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                          textStyle: MaterialStateProperty.all(
                                              const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                          overlayColor:
                                              MaterialStateProperty.resolveWith(
                                            (states) {
                                              return states.contains(
                                                      MaterialState.pressed)
                                                  ? Colors.white
                                                  : null;
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: height * 0.03),
                                Text(
                                  name,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  address,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(fontWeight: FontWeight.w300),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      border: Border.all(
                                          width: 0.5,
                                          color: const Color.fromRGBO(
                                              0, 0, 0, 0.1)),
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.05),
                                          blurRadius: 10,
                                          offset: Offset(0, 5),
                                        ),
                                      ]),
                                  child: DefaultTextStyle(
                                    style:
                                        Theme.of(context).textTheme.headline1!,
                                    child: Row(children: [
                                      Expanded(
                                        child: Column(children: [
                                          Text(postsNumber.toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 8),
                                          Text('Posts',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                        ]),
                                      ),
                                      Expanded(
                                        child: Column(children: [
                                          Text(followers.toString(),
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(height: 8),
                                          Text('Followers',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                        ]),
                                      ),
                                      Expanded(
                                        child: Column(children: [
                                          Text(
                                            following.toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 8),
                                          Text('Following',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600)),
                                        ]),
                                      ),
                                    ]),
                                  ),
                                ),
                                GridView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 5,
                                      crossAxisSpacing: 5,
                                      childAspectRatio: 6 / 5,
                                      crossAxisCount: 3,
                                    ),
                                    itemCount: posts.length,
                                    itemBuilder: (context, index) {

                                      var postUrl = values[index];

                                      var  fileType = values[index].split(".").last[0];
                                      print('filetype ='+ fileType);

                                      return
                                        fileType != 'i'?ChewieListItem(
                                          controlsPlace: 80,
                                          videoPlayerController:
                                          VideoPlayerController.network(postUrl),
                                        ):Container(
                                        color: Colors.grey,
                                        child:  Image(
                                          fit: BoxFit.fill,
                                          image:
                                              NetworkImage(postUrl),
                                        ),
                                      );
                                    }),
                                InkWell(
                                  onTap: () {
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(SignOutEvent());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: primaryGradient,
                                    ),
                                    height: height * 0.05,
                                    width: width * 0.4,
                                    child: Center(
                                      child: const Text(
                                        'Sign out',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: height * 0.08),
                              ]),
                            );
                          }
                        }),
                    fallback: (context) => Padding(
                          padding: EdgeInsets.only(top: height * 0.3),
                          child: const SpinKitCircle(
                            color: Colors.black,
                            size: 40,
                          ),
                        ));
              },
            ),
          ]),
        ),
      ),
    );
  }
}
