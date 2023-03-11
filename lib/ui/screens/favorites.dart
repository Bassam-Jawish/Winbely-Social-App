import 'package:chat_app/bloc/favorites/favorites_bloc.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Container(
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  'Favorites',
                  style: TextStyle(
                      fontSize: 30,
                      color: gradientEnd,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic),
                )),
            BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                if (state is GetFavoritesPostsSuccess) {
                  return StreamBuilder(
                    stream: state.stream,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //if (snapshot.connectionState == ConnectionState.waiting){
                      if (!snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.only(top: height * 0.3),
                          child: const SpinKitCircle(
                            color: Colors.white,
                            size: 40,
                          ),
                        );
                      }

                      return ListView.separated(
                          //controller: controller,
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.04),
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
                            var postUrl = snapshot.data!.docs[index]['postUrl'];
                            var description =
                                snapshot.data!.docs[index]['description'];
                            var time = snapshot.data!.docs[index]['time'];

                            var fileType = postUrl.split(".").last[0];

                            print(fileType);

                            //postId
                            var postId = snapshot.data!.docs[index]['postId'];

/*
                            var name = snapshot.data![index]['name'];
                            var profileUrl =
                                snapshot.data![index]['profileUrl'];
                            var postUrl = snapshot.data![index]['postUrl'];
                            var description =
                                snapshot.data![index]['description'];
                            var time = timeago.format(
                                (snapshot.data![index]['time']).toDate());

                            var fileType = postUrl.split(".").last[0];

                            print(fileType);
*/
                            return buildPostFavorites(
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
                }
                return Container();
              },
            ),
            SizedBox(
              height: height * 0.09,
            )
          ],
        ),
      ),
    );
  }
}
