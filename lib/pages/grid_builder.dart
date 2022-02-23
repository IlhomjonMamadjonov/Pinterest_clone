import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_demo/models/splash_model.dart';
import 'package:unsplash_demo/pages/detail_page.dart';
import 'package:unsplash_demo/services/utils_service.dart';

class GridBuilder extends StatelessWidget {
  UnSplash post;
  String? search;
  Map shares = {
    "Send": "assets/share/send.png",
    "WhatsApp": "assets/share/whatsapp.png",
    "Facebook": "assets/share/facebook.png",
    "Messages": "assets/share/message.png",
    "Gmail": "assets/share/gmail.png",
    "Telegram": "assets/share/telegram.png",
    "Copy link": "assets/share/copy_link.png",
    "More": "assets/share/more.png",
  };

  GridBuilder({Key? key, required this.post, this.search}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                      post: post,
                      search: search,
                    )));
      },
      child: Column(
        children: [
          /// #Post image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: post.urls!.regular!,
              placeholder: (context, url) => AspectRatio(
                aspectRatio: post.width! / post.height!,
                child: Container(
                  color: Utils.getColorFromHex(post.color!),
                ),
              ),
              errorWidget: (context, url, error) => AspectRatio(
                aspectRatio: post.width! / post.height!,
                child: Container(
                  color: Utils.getColorFromHex(post.color!),
                ),
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            minVerticalPadding: 0,
            horizontalTitleGap: 0,

            /// #profile image
            leading: SizedBox(
              height: 30,
              width: 30,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: post.user!.profileImage!.small!,
                  placeholder: (context, url) =>
                      Image.asset("assets/images/default.png"),
                  errorWidget: (context, url, error) =>
                      Image.asset("assets/images/default.png"),
                ),
              ),
            ),

            /// #userName
            title: Text(
              post.user!.name!,
              maxLines: 1,
            ),

            /// #more option
            trailing: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                moreOptions(context);
              },
              child: Icon(
                Icons.more_horiz,
                color: Colors.black,
              ),
            ),

            /// #Likes
            subtitle: post.likes != 0
                ? Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 18,
                      ),
                      post.likes! < 1000
                          ? Text(
                              " ${post.likes}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Text(
                              " ${post.likes! ~/ 100}k",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                    ],
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void moreOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height*0.45,
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    horizontalTitleGap: 0,
                    leading: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    title: Text(
                      "Share to",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // height: MediaQuery.of(context).size.height*0.1,
                    height: 90,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: shares.length,
                        itemBuilder: (context, i) {
                          return shareMethod(shares.values.elementAt(i),
                              shares.keys.elementAt(i));
                        }),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Hide Pins",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "See fewer Pins like this",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                        onTap: () {},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Report Pin",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "This goes against Pinterest's Community Guidelines",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget shareMethod(String image, String name) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Image.asset(
            image,
            height: 60,
            width: 80,
            fit: BoxFit.fitHeight,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            " $name ",
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}
