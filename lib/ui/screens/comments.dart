import 'package:chat_app/bloc/comments/comments_bloc.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatelessWidget {
  Comments({Key? key}) : super(key: key);

  var commentController = TextEditingController();
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBarComment(context),
        body: BlocBuilder<CommentsBloc, CommentsState>(
          builder: (context, state) {
            if (state is ShowCommentsSuccess) {
              return Column(
                children: [
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.07,
                              vertical: height * 0.01),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        commentDesc!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: height * 0.008),
                                      Row(
                                        children: [
                                          Text(
                                            commentTime!,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const LikeButton(
                                    //onTap: (v){},
                                    size: 25.0,
                                    circleColor: CircleColor(
                                        start: Color(0xffFFC0CB),
                                        end: Color(0xffff0000)),
                                    bubblesColor: BubblesColor(
                                        dotPrimaryColor: Color(0xffFFA500),
                                        dotSecondaryColor: Color(0xffd8392b),
                                        dotThirdColor: Color(0xffFF69B4),
                                        dotLastColor: Color(0xffff8c00)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(thickness: 1),
                        SizedBox(height: 5,),
                        Flexible(
                          child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 0.5,
                                  width: width / 1.3,
                                ),
                              );
                            },
                            scrollDirection: Axis.vertical,
                            itemCount: state.result.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              var name = state.result[index]['name'];
                              var profileUrl =
                                  state.result[index]['profileUrl'];
                              var time = timeago.format(
                                  (state.result[index]['time']).toDate());
                              var comment = state.result[index]['comment'];

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.06),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 20.0,
                                          backgroundImage:
                                              NetworkImage(profileUrl),
                                        ),
                                        SizedBox(width: width * 0.03),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            Text(
                                              time,
                                              style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 50.0),
                                      child: Text(
                                        comment,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                        ),
                        constraints: BoxConstraints(
                          maxHeight: 190.0,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(1),
                                  title: TextFormField(
                                    controller: commentController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10.0),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color: primaryColor,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color: primaryColor,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: BorderSide(
                                          color: primaryColor,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: primaryColor,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      hintText: "Write your comment...",
                                      hintStyle: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    maxLines: null,
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<CommentsBloc>(context)
                                          .add(AddCommentsEvent(
                                        comment: commentController.text,
                                      ));
                                      commentController.clear();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Icon(
                                        Icons.send,
                                        color: primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              print('loaddddddddd');
              BlocProvider.of<CommentsBloc>(context).add(ShowCommentsEvent());
              return Shimmer.fromColors(
                  baseColor: Colors.blueGrey,
                  highlightColor: Colors.grey[300]!,
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 15,
                          width: width / 1.3,
                        ),
                      );
                    },
                    itemCount: 12,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) =>
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 23),
                          child: Row(
                            children: [
                              Skelton(45.0, 45.0, 50.0),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Skelton(80.0, 16.0, 16.0),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Skelton(60.0, 14.0, 16.0),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Skelton(170.0, 18.0, 16.0),
                                    ],
                                  ))
                            ],
                          ),
                        )
                ),
              );
            }
          },
        ),
      ),
    );
    /* else if (state is ShowCommentsLoading) {
          return Padding(
            padding: EdgeInsets.only(top: height * 0.3),
            child: const SpinKitCircle(
              color: Colors.black,
              size: 40,
            ),
          );
        } else {
          return Container();
        }*/
  }

  appBarComment(context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/home');
        },
        child: const Icon(
          Icons.cancel,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      title: const Text(
        'Comments',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Skelton(double width, double height, double radius) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
