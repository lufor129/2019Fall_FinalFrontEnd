import 'package:flutter/material.dart';
import 'package:news_platform/models/Candidate.dart';
import 'package:news_platform/widget/circular_clipper.dart';
import 'package:news_platform/models/News.dart';
import 'dart:convert';
import 'package:news_platform/widget/StaticData.dart';
import 'package:requests/requests.dart';
import 'package:news_platform/widget/NewsWidget.dart';

class CandidateScreen extends StatefulWidget{

  final Candidate candidate;
  CandidateScreen({this.candidate});
  _CandidateScreenState createState() => _CandidateScreenState();
}

class _CandidateScreenState extends State<CandidateScreen>{

  // Widget newsList = Center(child:CircularProgressIndicator());

  // @override
  // void initState() {
  //   super.initState();
  //   _getNewsList();
  // }

  // void _getNewsList() async{
  //   http.Response response = await http.get(
  //     "http://140.127.220.185:6000/searchParty"
  //   );
  //   List list = jsonDecode(response.body);
  //   list = list.map((model)=>News.fromJson(model)).toList();
  //   setState(() {
  //     newsList = Column(
  //       children: list.map<Widget>((news)=>newsWidget(news)).toList(),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                transform: Matrix4.translationValues(0, -50, 0),
                child: Hero(
                  tag: widget.candidate.imageUrl,
                  child: ClipShadowPath(
                    clipper: CircularClipper(),
                    shadow: Shadow(blurRadius: 20),
                    child: Image(
                      image: AssetImage(widget.candidate.imageUrl),
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.arrow_back),
                      padding: EdgeInsets.only(left: 30),
                      iconSize: 40,
                      onPressed: ()=>Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.candidate.title,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "重要人物",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          widget.candidate.importP,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ]
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "國會席次",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          widget.candidate.congressSeat.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          ),
                        )
                      ]
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
          // newsList
          FutureBuilder(
            future: Requests.get(serverLink+"/searchParty?key=${widget.candidate.code}"),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                var list = json.decode(snapshot.data.content())["data"];
                var newsList = list.map((model)=>News.fromJson(model)).toList();
                return Column(
                  children: newsList.map<Widget>((news)=>NewsWidget(news: news)).toList(),
                );
              }else if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active){
                return Center(
                  child: CircularProgressIndicator()
                );
              }else{
                return Center(
                  child: Text(
                    "${widget.candidate.description}\n\n出現神奇的bug....\n建議檢查網路或退出重新整理!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ); 
              }
            },
          )
        ],
      ),
    );
  }

  // Widget newsWidget(News news){
  //   return InkWell(
  //     onTap: ()=>Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => NewsScreen(news: news)
  //       ),
  //     ),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(50),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black54,
  //             offset: Offset(0, 4),
  //             blurRadius: 10
  //           )
  //         ]
  //       ),
  //       width: double.infinity,
  //       height: 200,
  //       margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: <Widget>[
  //           Hero(
  //             tag: news.imgUrl,
  //             child: CachedNetworkImage(
  //               imageUrl: "https://lufor129.nctu.me/images/"+news.imgUrl.substring(6),
  //               placeholder: (context, url) => Center(child:CircularProgressIndicator()),
  //               errorWidget: (context, url, error) => Icon(Icons.error,color: Colors.amberAccent,size: 45),
  //               imageBuilder: (context,imageProvider) => Container(
  //                 height: 200,
  //                 width: 150,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(50),bottomLeft: Radius.circular(50)),
  //                     image: DecorationImage(
  //                     image: imageProvider,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 )
  //               )
  //             ),
  //           ),
  //           Expanded(
  //             child: Padding(
  //               padding: EdgeInsets.symmetric(horizontal: 10),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,  
  //                 children: <Widget>[
  //                   Text(
  //                     news.title,
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold
  //                     ),
  //                   ),
  //                   Text(
  //                     news.time.replaceAll("_", " ")
  //                   ),
  //                   Container(
  //                     padding: EdgeInsets.all(5),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(15),
  //                       color: Colors.amberAccent
  //                     ),
  //                     child: Text(
  //                       news.tag,
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             )
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
}


