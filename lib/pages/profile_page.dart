import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Profilepage extends StatefulWidget {
  static const String id = "/profile_page";

  @override
  _ProfilepageState createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Icon(
            Icons.share,
            color: Colors.black,
            size: 30,
          ),
          SizedBox(
            width: 15,
          ),
          Icon(
            Icons.more_horiz,
            color: Colors.black,
            size: 30,
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    "assets/images/user.jpg",
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Ilhomjon",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "@Ilhomjon_Mamadjonov",
                style: TextStyle(
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "0 followers • 0 following",
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 6,
                    child: TextField(
                      decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(left: 10),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(50)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(50)),
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          prefixIcon: Icon(
                            Icons.search,
                            size: 30,
                            color: Colors.grey,
                          ),
                          hintText: "Search your Pins",
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.grey)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset("assets/images/filter.svg",
                          height: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {},
                      child:
                          SvgPicture.asset("assets/images/add.svg", height: 20),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 80,
              ),
              Text(
                "You haven't saved any ideas yet",
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
              SizedBox(height: 30,),
              MaterialButton(
                height: 50,
                minWidth: 100,
                shape: StadiumBorder(),
                onPressed: () {},
                color: Colors.grey.shade200,
                child: Text("Find ideas",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
