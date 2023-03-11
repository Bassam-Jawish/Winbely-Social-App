import 'package:chat_app/bloc/comments/comments_bloc.dart';
import 'package:chat_app/bloc/favorites/favorites_bloc.dart';
import 'package:chat_app/bloc/home_screen/home_bloc.dart';
import 'package:chat_app/bloc/internet_connection/internet_bloc.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:chat_app/ui/components/components.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  //Note: we use snapshots with stream and getdocuments with normal builder
  /*var stream = FirebaseFirestore.instance
      .collection('PostsData')
      .orderBy('time', descending: true)
      .limit(5)
      .snapshots();*/

  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocListener<InternetBloc, InternetState>(
      listener: (context, state) {
        if (state is NotConnectedState) {
          buildNotConnectedDialog(context);
        }

        if (state is ConnectedState &&
            BlocProvider.of<InternetBloc>(context).show == true) {
          //Navigator.of(context).pushNamed('/');
          //Navigator.pop(context);
          //Navigator.pop(context);
          buildConnectedDialog(context);
        }
      },
      child: BlocListener<CommentsBloc, CommentsState>(
        listener: (context, state) {
          if (state is ShowCommentsSuccess) {
            /* Navigator.of(context)
          .pushReplacementNamed('/comments');*/
          }
        },
        child: BlocListener<FavoritesBloc, FavoritesState>(
          listener: (context, state) {
            if (state is addFavoritesSuccess) {
              showToast(text: 'Added  to favorites', state: ToastState.success);
            }
          },
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: appBar(context),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is GetPostsSuccess) {
                        return StreamBuilder(
                          stream: state.stream,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            //if (snapshot.connectionState == ConnectionState.waiting){
                            if (!snapshot.hasData) {
                              return Padding(
                                padding: EdgeInsets.only(top: height * 0.3),
                                child: const SpinKitCircle(
                                  color: Colors.black,
                                  size: 40,
                                ),
                              );
                            }

                            return ListView.separated(
                                //controller: controller,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.04),
                                scrollDirection: Axis.vertical,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                //itemCount: snapshot.data.length,
                                separatorBuilder: (context, index) => SizedBox(
                                      height: height * 0.02,
                                    ),
                                itemBuilder: (context, index) {
                                  /*controller.addListener(() {
                              print('hello');
                              if (controller.position.pixels ==
                                  controller.position.maxScrollExtent) {
                                BlocProvider.of<HomeBloc>(context).add(GetPostsHomeEvent());
                              }
                            });*/
                                  /*if (controller.position.pixels ==
                                    controller.position.maxScrollExtent &&
                                controller.position.pixels != null &&
                                controller.position.maxScrollExtent != null) {
                              BlocProvider.of<HomeBloc>(context)
                                  .add(GetPostsHomeEvent());
                            }*/
                                  /*if (controller.offset >=
                              (controller.position.maxScrollExtent) &&
                              !controller.position.outOfRange) {
                            BlocProvider.of<HomeBloc>(context).add(GetPostsHomeEvent());
                          }*/

                                  var name = snapshot.data!.docs[index]['name'];
                                  var profileUrl =
                                      snapshot.data!.docs[index]['profileUrl'];
                                  var postUrl =
                                      snapshot.data!.docs[index]['postUrl'];
                                  var description =
                                      snapshot.data!.docs[index]['description'];
                                  var time = timeago.format(
                                      (snapshot.data!.docs[index]['time'])
                                          .toDate());

                                  var fileType = postUrl.split(".").last[0];

                                  print(fileType);

                                  //postId
                                  var postId =
                                      snapshot.data!.docs[index]['postId'];

                                  return buildPostHome(
                                      context,
                                      width,
                                      height,
                                      name,
                                      profileUrl,
                                      postUrl,
                                      fileType,
                                      description,
                                      time,
                                      postId);
                                });
                          },
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(top: height * 0.3),
                          child: const SpinKitCircle(
                            color: Colors.black,
                            size: 40,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: height * 0.09,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
