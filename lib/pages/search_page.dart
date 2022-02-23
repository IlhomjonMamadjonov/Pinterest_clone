import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash_demo/models/splash_model.dart';
import 'package:unsplash_demo/pages/grid_builder.dart';
import 'package:unsplash_demo/services/http_service.dart';
import 'package:unsplash_demo/services/utils_service.dart';

class SearchPage extends StatefulWidget {
  static const String id = "/search_page";

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textEditingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isTapped = false;
  List<UnSplash> listOfPosts = [];
  String text = "";
  int pageNumber = 0;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          loading = true;
        });
        search();
      }
    });
  }

  void search() async {
    pageNumber += 1;
    String? response = await Network.GET(
        Network.API_SEARCH, Network.paramSearch(text, pageNumber));
    List<UnSplash> newItems = Network.parseSearch(response!);
    setState(() {
      if (pageNumber == 1) {
        listOfPosts = newItems;
      } else {
        listOfPosts.addAll(newItems);
      }
      loading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          margin: EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
          child: Row(
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _textEditingController,
                    style: TextStyle(fontSize: 18),
                    // onSubmitted: (text) {
                    //   setState(() {
                    //     isTapped = false;
                    //     if (text != _textEditingController.text.trim()) {
                    //       pageNumber = 0;
                    //       text = _textEditingController.text.trim();
                    //     }
                    //   });
                    //   search();
                    // },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        loading = true;
                        if (search != _textEditingController.text.trim())
                          pageNumber = 0;
                        text = _textEditingController.text.trim();
                      });
                      search();
                    },
                    onTap: () {
                      setState(() {
                        isTapped = true;
                      });
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: !isTapped
                            ? Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 30,
                              )
                            : null,
                        suffixIcon: Icon(
                          CupertinoIcons.camera_fill,
                          color: Colors.black,
                        ),
                        hintText: "Search for ideas",
                        hintStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              isTapped
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          isTapped = false;
                          listOfPosts.clear();
                          _textEditingController.clear();
                          pageNumber = 0;
                        });
                      },
                      child: Text(
                        " Cancel",
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                  return GridBuilder(post: listOfPosts[index], search:text);
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
    );
  }

  Widget buildPost(UnSplash post, search) {
    return Column(
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
                              fontWeight: FontWeight.bold,
                            ),
                          )
                  ],
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
