import 'package:chat_app/bloc/chat/chat_bloc.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:chat_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Public_Chats extends StatelessWidget {
  const Public_Chats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        systemNavigationBarColor: backgroundColor,
      ),
    );
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBarBack(context),
          body: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is showUsersChatsSuccess) {
                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(top: 40),
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 30.0, left: 30.0, right: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding:
                                    EdgeInsets.only(top: 1.0, bottom: 20.0),
                                child: Text(
                                  "Chats",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 40.0,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0),
                                height: 50.0,
                                width: width,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.only(top: 15.0),
                                    hintText: 'Search...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey.withOpacity(0.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "ONLINE USERS",
                                      style: TextStyle(
                                        color: Colors.grey.withOpacity(0.6),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      height: 100.0,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: userOnlineList.length,
                                          itemBuilder: (context, index) {

                                            var name = userOnlineList[index].name;
                                            var imgUrl = userOnlineList[index].ImageURL;

                                            return buildCard(context, name, imgUrl);
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 500.0,
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        BlocProvider.of<ChatBloc>(context)
                                            .usersResult
                                            .length,
                                    itemBuilder: (context, index) {
                                      List usersData =
                                          BlocProvider.of<ChatBloc>(context)
                                              .usersResult;

                                      var name = usersData[index]['name'];
                                      var profileUrl =
                                          usersData[index]['profileUrl'];
                                      var userId = usersData[index]['userId'];

                                      print(name);
                                      print(profileUrl);
                                      print(userId);

                                      return buildChatTile(
                                          context, name, profileUrl, userId);
                                    }),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                BlocProvider.of<ChatBloc>(context).add(ShowUsersChatsEvent());
                return Padding(
                  padding: EdgeInsets.only(bottom: height * 0.25),
                  child: const SpinKitCircle(
                    color: Colors.black,
                    size: 40,
                  ),
                );
              }
            },
          )),
    );
  }

  buildCard(context, name, imgUrl) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {},
          child: Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 8.0),
                height: 70.0,
                width: 70.0,
                decoration:  BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imgUrl),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Positioned(
                bottom: 10.0,
                right: 3.0,
                child: Container(
                  height: 15.0,
                  width: 15.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.0),
                    color: Colors.lightGreen,
                  ),
                ),
              ),
            ],
          ),
        ),
         Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  buildChatTile(context, name, profileUrl, userId) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              peerId = userId;
              peerName = name;
              peerProfileUrl = profileUrl;
              Navigator.of(context).pushNamed('/private_chat');
            },
            child: Stack(
              children: [
                Hero(
                  tag: profileUrl,
                  child: Container(
                    margin: EdgeInsets.only(right: 8.0, bottom: 10.0),
                    height: 70.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(profileUrl),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                //chat.unreadCount == 0 ? Container() : unreadCount
              ],
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                peerId = userId;
                peerName = name;
                peerProfileUrl = profileUrl;

                Navigator.of(context).pushNamed('/private_chat');
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Hero(
                      tag: name,
                      child: Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    Text(
                      'Hello',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                        color: Colors.grey.withOpacity(0.6),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnlineUsers {
  final String name;
  final String ImageURL;

  OnlineUsers(this.name, this.ImageURL);
}

List<OnlineUsers> userOnlineList = [
  OnlineUsers('Bassam', 'All'),
  OnlineUsers('Gorage', 'Medicine'),
  OnlineUsers('Zein', 'Career'),
  OnlineUsers('Mike', 'Psychology'),
  OnlineUsers('Dream', 'Family'),
  OnlineUsers('Hero', 'Management'),
  OnlineUsers('Peter', 'Others'),
];
