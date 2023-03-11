import 'package:chat_app/bloc/follow_helper/follow_helper_bloc.dart';
import 'package:chat_app/bloc/search_people/search_bloc.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {},
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: appBar(context),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.035),
              child: ListView(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  SizedBox(height: height * 0.04),
                  searchWidget(context),
                  SizedBox(height: height * 0.04),
                  BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state is SearchLoadingState) {
                        return Padding(
                          padding: EdgeInsets.only(top: height * 0.3),
                          child: const SpinKitCircle(
                            color: Colors.black,
                            size: 40,
                          ),
                        );
                      }
                      if (state is SearchSuccessState) {
                        return ListView.separated(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => SizedBox(
                            height: height * 0.025,
                          ),
                          itemCount: state.result.length,
                          itemBuilder: (context, index) {
                            var name = state.result[index]['name'];
                            var address = state.result[index]['address'];
                            var profileUrl = state.result[index]['profileUrl'];

                            var userId = state.result[index]['userId'];

                            return personCard(context, height, width, name,
                                address, profileUrl, userId);
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  searchWidget(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(width: 0.1, color: Colors.black),
      ),
      child: TextFormField(
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,
        onFieldSubmitted: (String value) {},
        onChanged: (String query) {
          BlocProvider.of<SearchBloc>(context)
              .add(SearchProcessEvent(query: query));
        },
        decoration: InputDecoration(
          labelText: 'Search',
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          labelStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: const BorderSide(
              color: Colors.black,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  personCard(context, height, width, name, address, profileUrl, userId) {
    return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(profileUrl),
          radius: 28.0,
        ),
        title: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
        subtitle: Text(
          address,
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
        trailing: BlocBuilder<FollowHelperBloc, FollowHelperState>(
          builder: (context, state) {
            if (state is! FollowLSuccessState) {
              return InkWell(
              onTap: () {
                BlocProvider.of<FollowHelperBloc>(context)
                    .add(FollowEvent(followUserId: userId));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: primaryGradient,
                ),
                height: height * 0.03,
                width: width * 0.2,
                child: Center(
                  child: const Text(
                    'Follow',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
            } else if(state is! UnfollowLSuccessState){
              return InkWell(
              onTap: () {
                BlocProvider.of<FollowHelperBloc>(context)
                    .add(UnfollowEvent(unfollowUserId: userId));
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  //gradient: primaryGradient,
                  color: Colors.orangeAccent
                ),
                height: height * 0.03,
                width: width * 0.3,
                child: Center(
                  child: const Text(
                    'Unfollow',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
            }
            return Container();
          },
        ));
  }
}
