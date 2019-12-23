import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_platform/models/Candidate.dart';
import 'package:news_platform/models/News.dart';
import 'package:news_platform/screen/CandidateScreen.dart';
import 'package:news_platform/models/tags.dart';
import 'package:news_platform/screen/NewsKindScreen.dart';
import 'package:news_platform/screen/NewsScreen.dart';
import 'package:news_platform/widget/content_scoller.dart';
import 'dart:convert';
import 'package:news_platform/widget/StaticData.dart';
import 'package:requests/requests.dart';
import 'package:news_platform/screen/SearchScreen.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class HomeScreen extends StatefulWidget{

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  
  PageController _pageController;
  List<News> recommendList = [];
  bool isWaiting = false;

  void _getloveNewsList() async{
    Response response = await Requests.get(
      serverLink+"/getFavorite"
    );
    List list = jsonDecode(response.content());
    if(list.length == 0){
      list = [].cast<News>();
    }else{
      list = list.map((model)=>News.fromJson(model)).toList();
    }
    setState(() {
      LoveNews.loveNewsList = list.reversed.toList();
    });
  }

  void _getrecommendNewsList() async{
    setState(() {
      isWaiting =true;
    });
    Response response = await Requests.get(
      serverLink+"/getRecomm"
    );
    List list = jsonDecode(response.content());
    list = list.map((model)=>News.fromJson(model["imgUrl"])).toList();
    setState(() {
      recommendList = list;
      isWaiting = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8,initialPage:1);
    _getloveNewsList();
    _getrecommendNewsList();
  }

  Widget _candidateSelector(int index){
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context,Widget widget){
        double value = 1;
        if(_pageController.position.haveDimensions){
          value = _pageController.page - index;
          value = (1-(value.abs()*0.3)+0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value)*270,
            width: Curves.easeInOut.transform(value)*400,
            child: widget,
          ),
        );
      },
      child: GestureDetector(
        onTap: ()=> Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CandidateScreen(candidate: candidates[index])
          )
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0, 4),
                      blurRadius: 10
                    )
                  ]
                ),
                child: Center(
                  child: Hero(
                    tag: candidates[index].imageUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: AssetImage(candidates[index].imageUrl),
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 30,
              bottom: 40,
              child: Container(
                width: 250,
                child: Text(
                  candidates[index].title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, 4),
              blurRadius: 10
            )
          ]
        ),
        child: IconButton(
          icon: Icon(Icons.visibility,size: 30),
          onPressed: ()=>Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (_)=> new SearchScreen(
                isSearch: false,
              )
            )
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        
        title:Text(
          "Anti-Fakes",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30,
            onPressed: ()=>Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (_)=> new SearchScreen(
                  isSearch: true,
                )
              )
            ),
            color: Colors.black,
            padding: EdgeInsets.only(right:30),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top:10,left: 30),
            child: Text(
              "決戰2020特別整理報導",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            height: 280,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: candidates.length,
              itemBuilder: (BuildContext context,int index){
                return _candidateSelector(index);
              },
            ),
          ),
          Container(
            height: 90,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 30),
              scrollDirection: Axis.horizontal,
              itemCount: taglist.length,
              itemBuilder: (BuildContext context,int index){
                return InkWell(
                  onTap: ()=>Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewsKindScreen(newsTag: taglist[index])
                    )
                  ),
                  child:Container(
                    margin: EdgeInsets.all(10),
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      // color: taglist[index].color,
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(int.parse("#F2F2F2".replaceAll("#","0xff"))),
                          Color(int.parse("#DBDBDB".replaceAll("#","0xff"))),
                          Color(int.parse("#EAEAEA".replaceAll("#","0xff"))),
                        ]
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          offset: Offset(0.0,1.0),
                          blurRadius: 6
                        )
                      ]
                    ),
                    child: Center(
                      child: Hero(
                        tag: taglist[index],
                        child: Text(
                          taglist[index],
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.8,
                          ),
                        ),
                      ),
                    ),
                  )
                );
              },
            ),
          ),
          SizedBox(height: 20.0),
          LoveNews.loveNewsList.length == 0? new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "My Favorite",
                  style:TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                height: 100,
                child: Center(
                  child: Text(
                    "添加最愛新聞",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              )
            ],
          ):
          ContentScroll(
            newList: LoveNews.loveNewsList,
            title: "My Favorite",
            imageHeight: 250,
            imageWidth: 150,
          ),
          SizedBox(height: 20.0),
          // recommendList .length==0? new Container():
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Recommend you",
                      style:TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: ()=>_getrecommendNewsList(),
                      child: Icon(
                        Icons.replay,
                        color:Colors.black,
                        size:30
                      ),
                    )
                  ],
                ),
              ),
              isWaiting == true?new Container(
                height: 100,
                child: Center(
                  child:  CircularProgressIndicator(),
                ),
              ):recommendList .length==0? new Container(
                height: 100,
                child: Center(
                  child: Text(
                    "Add Favorite and reload",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ):
              Container(
                height: 250,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendList.length,
                  itemBuilder: (BuildContext context,int index){
                    return InkWell(
                      onTap: ()=> Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:(_)=>NewsScreen(news: recommendList[index])
                        )
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20
                          ),
                          width: 150,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                offset: Offset(0,5),
                                blurRadius: 6
                              )
                            ]
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: serverImageLink+recommendList[index].imgUrl.substring(6),
                                placeholder: (context, url) => Center(child:CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Center(child: Icon(Icons.error,size: 100,color: Colors.amberAccent,),),
                                fit: BoxFit.cover,
                              ),
                            ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}