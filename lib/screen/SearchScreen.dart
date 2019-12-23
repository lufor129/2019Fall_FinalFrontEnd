import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_platform/models/News.dart';
import 'package:news_platform/screen/NewsScreen.dart';
import 'package:news_platform/widget/StaticData.dart';
import 'package:requests/requests.dart';
import 'package:news_platform/widget/NewsWidget.dart';
import 'package:news_platform/screen/FeedbackScreen.dart';

class SearchScreen extends StatefulWidget{
  final bool isSearch;
  SearchScreen({this.isSearch});

  SearchScreenState createState() => new SearchScreenState();
}


class SearchScreenState extends State<SearchScreen>{
  String searchText = "";
  List<News> newslist = [];
  bool isWaiting = false;
  List<Object> lsi = [];
  List<Object> scores = [];
  List<Object> newsLabels;
  String finalTag = "";
  double score = 0;
  final label2Score={
    "agreed":1.0,
    "disagreed":-1.0,
    "unrelated":0
  };

  final label2Color={
    "agreed":Colors.green,
    "disagreed":Colors.red,
    "unrelated":Colors.amber
  };

  void _countScore(){
    double scoreT = 0;
    for(var i =0;i<scores.length;i++){
      scoreT += double.parse(lsi[i])*double.parse(scores[i])*label2Score[newsLabels[i]];
    }
    setState(() {
      score = scoreT;
      if(score>2.5){
        finalTag = "真新聞";
      }else if(score <0){
        finalTag = "假新聞";
      }else{
        finalTag = "有爭議或無法評定";
      }
    });
  }

  void _getTextandSearch() async{
    if(searchText == "") return;
    setState(() {
      isWaiting = true;
    });
    Response response = await Requests.get(
      serverLink+"/getSearching?text=$searchText"
    );
    List list = jsonDecode(response.content());
    setState(() {
      newslist = list.map((model)=>News.fromJson(model)).toList();
      isWaiting = false;
    });
  }

  void _getTextLSTM() async{
    if(searchText == "") return;
    setState(() {
      isWaiting = true;
    });
    Response response = await Requests.get(
      serverLink+"/FakeNewsJ/?text=$searchText"
    );
    var data = jsonDecode(response.content());
    // var data = tempData;
    List list = data["data"];
    lsi = data["lsi"];
    scores = data["pred_score"];
    newsLabels = data["label"];
    _countScore();
    setState(() {
      newslist = list.map((model)=>News.fromJson(model)).toList();
      isWaiting = false;
    });
  }

  Widget bodyList(){
    if(isWaiting == true){
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: CircularProgressIndicator()
        ),
      );
    }
    if(newslist.length==0){
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Text(
            "輸入點東西啦...",
            style:TextStyle(
              fontSize:30,
              color: Colors.black45
            )
          ),
        ),
      );
    }else{
      if(widget.isSearch){
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: newslist.length,
                itemBuilder: (context,index){
                  return NewsWidget(news: newslist[index]);
                },
              ),
            )
          ],
        );
      }else{
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: SizedBox(height:10),
              ),
              SliverAppBar(
                bottom: PreferredSize(child: new Text(''), preferredSize: Size.fromHeight(25.0)),
                backgroundColor: finalTag=="真新聞"?Colors.green[300]:finalTag=="假新聞"?Colors.red[400]:Colors.amber,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                expandedHeight: 80,
                automaticallyImplyLeading: false,
                pinned:false,
                floating: true,
                flexibleSpace: Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        finalTag,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                      Text(
                        "分數: $score",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black45
                        ),
                      )
                    ],
                  ),
                )
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context,index){
                    return judgeBox(newslist[index],lsi[index],scores[index],newsLabels[index]);
                  },
                  childCount: newslist.length
                )
              )
            ],
          ),
        );
      }
    }
  }

  Widget judgeBox(News news,String lsi,String score,String newsLabel){
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0,4),
            blurRadius: 1
          )
        ]
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20)),
            child: InkWell(
              onTap: ()=> Navigator.push(
                context,
                MaterialPageRoute(
                  builder:(_)=>NewsScreen(news: news)
                )
              ),
              child: CachedNetworkImage(
                imageUrl: serverImageLink+news.imgUrl.substring(6),
                placeholder: (context, url) => Center(child:CircularProgressIndicator()),
                errorWidget: (context, url, error) => Center(child: Icon(Icons.error,size: 100,color: Colors.amberAccent),),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  news.title,
                  style:TextStyle(
                    fontSize:18,
                    fontWeight:FontWeight.bold
                  )
                ),
                Text(
                  "與輸入的相關性: $lsi"
                ),
                Text(
                  "SoftMax機率: $score"
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(right: 20,bottom: 20),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: label2Color[newsLabel],
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(
                  newsLabel,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.isSearch?null:newslist.length!=0?Container(
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
          icon: Icon(Icons.feedback,size: 30),
          onPressed: ()=>Navigator.push(
            context,
            new MaterialPageRoute(
              builder: (_)=> FeedbackScreen(searchText: searchText,newslist:newslist,newsLabel: newsLabels)
            )
          ),
        ),
      ):null,
      appBar: PreferredSize(
        child: Container(
          height: 120,
          padding: EdgeInsets.only(top: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isSearch==true?Colors.amberAccent:Colors.blueAccent,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40)
            )
          ),
          child: ListTile(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: ()=>Navigator.pop(context),
            ),
            title: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white
              ),
              child: TextField(
                onChanged: (text)=>searchText=text,
                onSubmitted:(text)=>widget.isSearch?_getTextandSearch():_getTextLSTM(),
                style: TextStyle(
                  fontSize: 20
                ),
                decoration: InputDecoration(
                  hintText: widget.isSearch==true?"輸入想查詢的新聞標題":"輸入想查詢的假新聞",
                  hintStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  suffixIcon: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.black38,
                      onPressed: ()=>widget.isSearch?_getTextandSearch():_getTextLSTM(),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 13)
                ),
              ),
            ),
          ),
        ),
        preferredSize: Size.fromHeight(120),
      ),
      body: bodyList()
    );
  }
}