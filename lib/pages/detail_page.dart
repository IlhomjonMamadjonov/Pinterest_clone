import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash_demo/models/splash_model.dart';
import 'package:unsplash_demo/pages/grid_builder.dart';
import 'package:unsplash_demo/services/http_service.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, this.post, this.search}) : super(key: key);
  static const String id = "/detail_page";
  UnSplash? post;
  String? search;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<UnSplash> listOfPosts = [];
  int length = 0;
  final ScrollController _scrollController = ScrollController();
  int pageNumber = 0;
  bool loading = false;
  bool loadPage = false;

  void _loadPosts() async {
    await Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((response) => {showResponse(response!)});
  }

  void showResponse(String response) {
    setState(() {
      loading = false;
      listOfPosts = Network.parseResponse(response);
      length = listOfPosts.length;
    });
  }

  fetchPosts() async {
    int pageNum = (listOfPosts.length ~/ length + 1);
    String? response =
        await Network.GET(Network.API_LIST, Network.paramsPage(pageNum));
    List<UnSplash> freshPosts = Network.parseResponse(response!);
    listOfPosts.addAll(freshPosts);
    setState(() {
      loadPage = false;
    });
  }

  void search() async {
    pageNumber += 1;
    String? response = await Network.GET(
        Network.API_SEARCH, Network.paramSearch(widget.search!, pageNumber));
    List<UnSplash> newItems = Network.parseSearch(response!);
    setState(() {
      listOfPosts.addAll(newItems);
      loading = false;
      loadPage = false;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.search != null ? search() : _loadPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          loadPage = true;
        });
        widget.search != null ? search() : fetchPosts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// #First Part
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Column(
                  children: [
                    /// #post photo
                    ClipRRect(
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.post!.urls!.regular!,
                            placeholder: (context, index) =>
                                Image.asset("assets/images/default.png"),
                            errorWidget: (context, url, error) =>
                                Image.asset("assets/images/default.png"),
                          ),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    ListTile(
                      /// #profile img
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          height: 50,
                          imageUrl: widget.post!.user!.profileImage!.large!,
                          placeholder: (context, url) =>
                              Image.asset("assets/images/default.png"),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/images/default.png"),
                        ),
                      ),
                      title: Text(widget.post!.user!.name!),
                      subtitle: widget.post!.likes != 0
                          ? widget.post!.likes! < 1000
                              ? Text(
                                  "${widget.post!.likes} followers",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  "${widget.post!.likes! ~/ 100} followers",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                          : SizedBox.shrink(),
                      trailing: MaterialButton(
                        height: 40,
                        elevation: 0,
                        onPressed: () {},
                        shape: StadiumBorder(),
                        child: Text("Follow"),
                        color: Colors.grey.shade200,
                      ),
                    ),

                    /// #description
                    widget.post!.description != null
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              widget.post!.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        : SizedBox.shrink(),

                    /// #share&save buttons
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                CupertinoIcons.chat_bubble_fill,
                                size: 30,
                              ),
                              MaterialButton(
                                onPressed: () {},
                                elevation: 0,
                                height: 60,
                                color: Colors.grey.shade200,
                                shape: StadiumBorder(),
                                child: Text(
                                  "Read it",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            ],
                          )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MaterialButton(
                                onPressed: () {},
                                elevation: 0,
                                height: 60,
                                color: Colors.red,
                                shape: StadiumBorder(),
                                child: Text(
                                  "Save",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                              Icon(
                                Icons.share,
                                size: 30,
                              )
                            ],
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              /// $Second Part
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        "Share your feedback",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Love this Pin? let ",
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: widget.post!.user!.name,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ]),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: 0,
                      leading: SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            "assets/images/user.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: TextField(
                        decoration: InputDecoration(
                          hintText: "Add a comment",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(50)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                    ),
                    Center(
                      child: MaterialButton(
                        onPressed: () {},
                        color: Colors.grey.shade200,
                        shape: StadiumBorder(),
                        height: 40,
                        elevation: 0,
                        child: Text(
                          "See more comments",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              /// #Third Part
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        "More like this",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: listOfPosts.length,
                        crossAxisCount: 2,
                        mainAxisSpacing: 11,
                        crossAxisSpacing: 10,
                        itemBuilder: (context, index) {
                          return GridBuilder(
                            post: listOfPosts[index],
                            search: widget.search,
                          );
                        }),
                    loading || loadPage
                        ? Container(
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: const Center(
                              child: CircularProgressIndicator.adaptive(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black)),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
