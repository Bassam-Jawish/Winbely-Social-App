import 'package:chat_app/bloc/chat/chat_bloc.dart';
import 'package:chat_app/constants.dart';
import 'package:chat_app/themes/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:timeago/timeago.dart' as timeago;


class Private_Chat extends StatelessWidget {
  Private_Chat({Key? key}) : super(key: key);

  var messageController = TextEditingController();
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
        appBar: appBarPrivateChat(context, width, height),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state is showUserMessagesSuccess) {
              return StreamBuilder(
                  stream: state.stream,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                    return Column(
                      children: [
                        SizedBox(height: height*0.03,),
                        Flexible(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.05),
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            reverse: true,
                            itemBuilder: (BuildContext context, int index) {
                              var messageOwnerId =
                                  snapshot.data!.docs[index]['messageOwnerId'];
                              var messageContent =
                                  snapshot.data!.docs[index]['message'];
                              var time = timeago.format((snapshot.data!.docs[index]['time']).toDate());

                              return message(context, width, height, messageOwnerId, messageContent, time);
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: BottomAppBar(
                            elevation: 8.0,
                            child: Container(
                              constraints: BoxConstraints(maxHeight: 100.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.image,
                                      color: primaryColor,
                                    ),
                                    onPressed: () {},
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      controller: messageController,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        enabledBorder: InputBorder.none,
                                        border: InputBorder.none,
                                        hintText: "Type your message",
                                        hintStyle: TextStyle(
                                          color: primaryColor,
                                        ),
                                      ),
                                      maxLines: null,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.send,
                                      color: primaryColor,
                                    ),
                                    onPressed: () {
                                      BlocProvider.of<ChatBloc>(context).add(
                                          AddMessageEvent(
                                              message: messageController.text));
                                      messageController.clear();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );}
                    else{
                      return Padding(
                        padding: EdgeInsets.only(bottom: height * 0.25),
                        child: const SpinKitCircle(
                          color: Colors.black,
                          size: 40,
                        ),
                      );
                    }
                  });
            } else {
              print('loaaaaaaaad');
              BlocProvider.of<ChatBloc>(context).add(ShowUserMessagesEvent());
              return Padding(
                padding: EdgeInsets.only(bottom: height * 0.25),
                child: const SpinKitCircle(
                  color: Colors.black,
                  size: 40,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  appBarPrivateChat(context, width, height) {
    return AppBar(
      leading: Row(
        children: [
          GestureDetector(
            onTap: () {
              //BlocProvider.of<ChatBloc>(context).stream = null;
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.chevron_left,
              size: 30,
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      elevation: 0.0,
      title: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Hero(
                tag: peerProfileUrl!,
                child: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: NetworkImage(peerProfileUrl!),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    peerName!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.black),
                  ),
                  SizedBox(height: height * 0.005),
                  const Text(
                    'online',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  message(context, width, height, messageOwnerId, messageContent, time) {
    bool messageSide = FirebaseAuth.instance.currentUser!.uid == messageOwnerId;

    Color? chatBubbleColor() {
      if (messageSide) {
        return primaryColor;
      } else {
        return gradientEnd;
      }
    }

    return Column(
      crossAxisAlignment:
      messageSide ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ChatBubble(
          elevation: 0.0,
          padding: const EdgeInsets.all(4.0),
          alignment: messageSide ? Alignment.centerRight : Alignment.centerLeft,
          clipper: ChatBubbleClipper3(
            nipSize: 0,
            type: messageSide ? BubbleType.sendBubble : BubbleType.receiverBubble,
          ),
          backGroundColor: chatBubbleColor(),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              messageContent,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Padding(
          padding: messageSide
              ? EdgeInsets.only(
                  right: 6.0,
                  bottom: 10.0,
                )
              : EdgeInsets.only(
                  left: 6.0,
                  bottom: 10.0,
                ),
          child: Text(
            time,
            style: TextStyle(
              color: Colors.black,
              fontSize: 10.0,
            ),
          ),
        ),
      ],
    );
  }
}
