import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:unsplash_demo/models/splash_model.dart';
import 'package:unsplash_demo/pages/detail_page.dart';
import 'package:unsplash_demo/pages/grid_builder.dart';
import 'package:unsplash_demo/pages/profile_page.dart';
import 'package:unsplash_demo/pages/search_page.dart';
import 'package:unsplash_demo/services/http_service.dart';
import 'package:unsplash_demo/services/utils_service.dart';

import 'message_page.dart';

class HomePage extends StatefulWidget {
  static const String id = "/home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  bool loading = false;
  List<UnSplash> listOfPosts = [];
  int length = 0;
  final PageController _controller = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          loading = true;
        });
        fetchPosts();
      }
    });
  }

  void showResponse(String response) {
    setState(() {
      isLoading = false;
      listOfPosts = Network.parseResponse(response);
      listOfPosts.shuffle();
      length = listOfPosts.length;
    });
  }

  void _loadPosts() async {
    await Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((response) => {showResponse(response!)});
  }

  fetchPosts() async {
    int pageNum = (listOfPosts.length ~/ length + 1);
    String? response =
        await Network.GET(Network.API_LIST, Network.paramsPage(pageNum));
    List<UnSplash> freshPosts = Network.parseResponse(response!);
    listOfPosts.addAll(freshPosts);
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(Colors.black),
              ),
            )
          : WillPopScope(
              onWillPop: () async {
                if (_selectedIndex != 0) {
                  setState(() {
                    --_selectedIndex;
                    _controller.jumpToPage(_selectedIndex);
                  });
                  return false;
                } else {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else {
                    exit(0);
                  }
                  return false;
                }
              },
              child: PageView(
                onPageChanged: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 35, bottom: 10),
                        height: 80,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.16,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black,
                          ),
                          child: Text(
                            "All",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                        child: MasonryGridView.count(
                            controller: _scrollController,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            itemCount: listOfPosts.length,
                            crossAxisCount: 2,
                            mainAxisSpacing: 11,
                            crossAxisSpacing: 10,
                            itemBuilder: (context, index) {
                              return GridBuilder(post: listOfPosts[index],);
                            }),
                      ),
                      if (loading)
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                    ],
                  ),
                  const SearchPage(),
                  MessagePage(),
                  Profilepage()
                ],
              ),
            ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.04,
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _controller.jumpToPage(_selectedIndex);

          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/images/home.svg",
                    color: Colors.grey),
                activeIcon: SvgPicture.asset("assets/images/home.svg",
                    color: Colors.black),
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/images/search.svg"),
                activeIcon: SvgPicture.asset(
                  "assets/images/search.svg",
                  color: Colors.black,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: SvgPicture.asset("assets/images/message.svg"),
                activeIcon: SvgPicture.asset(
                  "assets/images/message.svg",
                  color: Colors.black,
                ),
                label: ""),
            BottomNavigationBarItem(
                icon: SizedBox(
                  height: 28,
                  width: 28,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "assets/images/user.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                label: "")
          ],
        ),
      ),
    );
  }

/*
  Widget buildPost(UnSplash post) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(post: post,)));
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
              onTap: () {},
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
                                  fontWeight: FontWeight.bold,),
                            )
                    ],
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

 */
}
