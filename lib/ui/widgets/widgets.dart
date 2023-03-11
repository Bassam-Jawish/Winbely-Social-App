import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/bloc/chat/chat_bloc.dart';
import 'package:chat_app/bloc/comments/comments_bloc.dart';
import 'package:chat_app/bloc/favorites/favorites_bloc.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:chat_app/ui/widgets/videoController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:like_button/like_button.dart';
import 'package:video_player/video_player.dart';

Widget defaulttextFormField(
        {TextEditingController? controller,
        required TextInputType keyboardType,
        String? labelText,
        TextStyle? labelStyle,
        Widget? prefixIcon,
        required Color borderColor,
        var maxLengthEnforcement,
        FormFieldValidator<String>? validator,
        AutovalidateMode? autovalidateMode,
        Function()? onPressedSuffix,
        IconData? suffix,
        bool obscureText = false,
        ValueChanged<String>? onFieldSubmitted,
        ValueChanged<String>? onChanged,
        GestureTapCallback? onTap,
        FocusNode? focusNode,
        double radius = 0.0,
        Color? cursorColor,
        int? maxLength,
        int maxLines = 1,
        key}) =>
    TextFormField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      autovalidateMode: autovalidateMode,
      validator: validator,
      obscureText: obscureText,
      cursorColor: cursorColor,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      onTap: onTap,
      maxLines: maxLines,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      decoration: InputDecoration(
        counterText: "",
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: onPressedSuffix,
                icon: Icon(suffix),
              )
            : null,
        labelText: labelText,
        labelStyle: labelStyle,
      ),
    );

AwesomeDialog buildConnectedDialog(context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.success,
    animType: AnimType.topSlide,
    title: 'Connected',
    desc: '',
    autoHide: const Duration(seconds: 3),
    dismissOnTouchOutside: true,
  )..show();
}

AwesomeDialog buildNotConnectedDialog(context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.rightSlide,
    title: 'No internet connection',
    desc: '',
    autoHide: const Duration(seconds: 2),
    dismissOnTouchOutside: true,
  )..show();
}

appBar(context) {
  return AppBar(
    backgroundColor: bottomNavBar,
    title: const Text(
      'Winbely',
      style: TextStyle(
          fontSize: 30, color: Colors.white, fontWeight: FontWeight.w900),
    ),
    centerTitle: true,
    actions: [
      IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/notif');
          },
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
            size: 25,
          )),
      IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/public_chats');
          },
          icon: const Icon(
            Icons.message,
            color: Colors.white,
            size: 25,
          )),
    ],
    shadowColor: buttonBackgroundColor,
  );
}

appBarBack(context) {
  return AppBar(
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.chevron_left,
        size: 40,
        color: Colors.black,
      ),
    ),
    backgroundColor: backgroundColor,
    elevation: 0.0,
  );
}

buildPostHome(context, width, height, name, profileUrl, postUrl, filetype,
    description, time, postId) {
  return Container(
      padding: EdgeInsets.only(top: height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.018),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(24),
                  child: CircleAvatar(
                    //backgroundImage: c.post?.avatarUrl != null ? NetworkImage(c.post!.avatarUrl!) : null,
                    backgroundImage: NetworkImage(profileUrl),
                    radius: 28,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  name,
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.002,
          ),
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
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            child: filetype != 'i'
                                ? ChewieListItem(
                                    controlsPlace: 20,
                                    videoPlayerController:
                                        VideoPlayerController.network(postUrl),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: postUrl,
                                    placeholder: (context, url) =>
                                        const SpinKitCircle(
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                    height: height * 0.4,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    //image: NetworkImage(postUrl),
                                  ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.01,
                                vertical: height * 0.02),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    LikeButton(
                                      onTap: (bool isLiked) async {
                                        BlocProvider.of<FavoritesBloc>(context)
                                            .add(addFavoritesEvent(
                                                imgUrl: postUrl,
                                                desc: description,
                                                postId: postId,
                                                name: name,
                                                profileUrl: profileUrl,
                                                time: time));
                                        return !isLiked;
                                      },
                                      likeBuilder: (isLiked) {
                                        return Icon(
                                          Icons.favorite,
                                          color: isLiked
                                              ? Colors.red
                                              : Colors.grey,
                                        );
                                      },
                                      size: 30.0,
                                    ),
                                    SizedBox(width: width * 0.01),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(10.0),
                                      onTap: () {
                                        commentName = name;
                                        commentProfileUrl = profileUrl;
                                        commentDesc = description;
                                        commentPostId = postId;
                                        commentTime = time;
                                        Navigator.of(context)
                                            .pushNamed('/comments');
                                      },
                                      child: const Icon(
                                        Icons.comment,
                                        size: 25.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.001),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: width * 0.03),
                                        child: const Text(
                                          '7',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.01),
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: width * 0.06),
                                        child: const Text(
                                          '3',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.01, top: height * 0.01),
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .color,
                                      fontSize: 18.0,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),

                                SizedBox(height: height * 0.001),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.05, top: height * 0.01),
                                  child: Text(
                                    time,
                                    style: const TextStyle(fontSize: 10.0),
                                  ),
                                ),
                                // SizedBox(height: 5.0),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )))
        ],
      ));
}

buildPostFavorites(context, width, height, name, profileUrl, postUrl, filetype,
    description, time, postId) {
  return Container(
      padding: EdgeInsets.only(top: height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.018),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(24),
                  child: CircleAvatar(
                    //backgroundImage: c.post?.avatarUrl != null ? NetworkImage(c.post!.avatarUrl!) : null,
                    backgroundImage: NetworkImage(profileUrl),
                    radius: 28,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  name,
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.002,
          ),
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
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                            child: filetype != 'i'
                                ? ChewieListItem(
                                    controlsPlace: 20,
                                    videoPlayerController:
                                        VideoPlayerController.network(postUrl),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: postUrl,
                                    placeholder: (context, url) =>
                                        const SpinKitCircle(
                                      color: Colors.black,
                                      size: 40,
                                    ),
                                    height: height * 0.4,
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    //image: NetworkImage(postUrl),
                                  ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.01,
                                vertical: height * 0.02),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    LikeButton(
                                      onTap: (bool isLiked) async {
                                        return !isLiked;
                                      },
                                      likeBuilder: (isLiked) {
                                        return Icon(Icons.favorite,
                                            color: Colors.red);
                                      },
                                      size: 30.0,
                                    ),
                                    SizedBox(width: width * 0.01),
                                    InkWell(
                                      borderRadius: BorderRadius.circular(10.0),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed('/comment');
                                      },
                                      child: const Icon(
                                        Icons.comment,
                                        size: 25.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height * 0.001),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: width * 0.03),
                                        child: const Text(
                                          '7',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.01),
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: width * 0.06),
                                        child: const Text(
                                          '3',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.01, top: height * 0.01),
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .color,
                                      fontSize: 18.0,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),

                                SizedBox(height: height * 0.001),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: width * 0.05, top: height * 0.01),
                                  child: Text(
                                    time,
                                    style: const TextStyle(fontSize: 10.0),
                                  ),
                                ),
                                // SizedBox(height: 5.0),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  )))
        ],
      ));
}
