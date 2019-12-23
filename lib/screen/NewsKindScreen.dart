import 'package:flutter/material.dart';
import 'package:news_platform/widget/cardScollWidget.dart';
import 'package:news_platform/models/News.dart';
import 'dart:convert';
import 'package:news_platform/screen/NewsScreen.dart';
import 'package:news_platform/widget/StaticData.dart';
import 'package:requests/requests.dart';

class NewsKindScreen extends StatefulWidget{

  final newsTag;
  NewsKindScreen({this.newsTag});

  _NewsKindScreenState createState() => _NewsKindScreenState();
}

class _NewsKindScreenState extends State<NewsKindScreen>{

  var currentPage;
  List<News> newsList = [];
  PageController controller;

  @override
  void initState() {
    super.initState();
    this._getNewsList();
  }

  
  void _getNewsList() async{
    Response response = await Requests.get(
      serverLink+"/newsKind?key=${widget.newsTag}"
    );
    List list = jsonDecode(response.content())["data"];
    setState(() {
      newsList = list.map((model)=>News.fromJson(model)).toList();
      newsList = newsList.reversed.toList();
      currentPage = newsList.length-1;
    });
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: newsList.length-1);
    controller.addListener((){
      setState(() {
        currentPage = controller.page;
      });
    });

    return Scaffold(
      backgroundColor: Color(int.parse("#F2F2F2".replaceAll("#","0xff"))),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Color(int.parse("#F2F2F2".replaceAll("#","0xff"))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black),
          onPressed: ()=>Navigator.pop(context),
        ),
        title:Hero(
          tag: widget.newsTag,
          child: Text(
            widget.newsTag,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.8,
            ),
          ),
        ),
      ),
      body:Container(
        child: newsList.length==0?Center(
            child: CircularProgressIndicator(),
          ):Stack(
          children: <Widget>[
            CardScollWidget(currentPage, newsList),
            Positioned.fill(
              child: PageView.builder(
                controller: controller,
                itemCount: newsList.length,
                reverse: true,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: ()=>Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsScreen(news: newsList[index])
                      ),
                    ),
                    child:Container()
                  );
                },
              ),
            )
          ],
        ),
      )
    );
  }
}

