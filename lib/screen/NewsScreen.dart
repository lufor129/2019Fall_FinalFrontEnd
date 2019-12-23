import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_platform/models/News.dart';
import 'package:news_platform/widget/StaticData.dart';
import 'package:requests/requests.dart';

class NewsScreen extends StatefulWidget{
  
  final news;
  // final isFavoirte;
  NewsScreen({this.news});
  _NewsScreen createState() => _NewsScreen();

}

class _NewsScreen extends State<NewsScreen> {
  
  bool isWaiting = false;
  bool isFavorite; 
  @override
  void initState() {
    super.initState();
    isFavorite = LoveNews.loveNewsList.any((n)=>n.imgUrl == widget.news.imgUrl);
  }

  _toggleFavorite() async{
    setState(() {
      isWaiting = true;
    });
    var response = await Requests.get(
      serverLink+"/toggleFavorite?url=${widget.news.imgUrl}"
    );
    setState(() {
      isFavorite = !isFavorite;
      print(response.content());
      if(response.content() == "delete completed"){
        LoveNews.loveNewsList.removeWhere((news)=>news.imgUrl == widget.news.imgUrl);
      }else{
        LoveNews.loveNewsList.insert(0,widget.news);
      }
      isWaiting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details){
          if (details.delta.dx > 8 || details.delta.dx<-8) {
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Hero(
                tag: widget.news.imgUrl,
                child: Container(
                  height: 350,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: serverImageLink+widget.news.imgUrl.substring(6),
                    placeholder: (context, url) => Center(child:CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error,size: 100,color: Colors.amberAccent,),),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow (
                      color: Colors.black54,
                      offset: Offset(0, 4),
                      blurRadius: 10
                    )
                  ]
                ),
                padding: EdgeInsets.all(15),
                width: double.infinity,
                margin: EdgeInsets.only(top: 200,left: 30,right: 30,bottom: 30),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.news.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.news.time.replaceAll("_", " ")
                              ),
                              isWaiting == true?
                              CircularProgressIndicator()
                              :IconButton(
                                padding: EdgeInsets.only(right: 10),
                                icon: Icon(
                                  isFavorite?Icons.favorite:Icons.favorite_border
                                ),
                                // onPressed: ()=>setState(()=>{
                                //   isFavorite = !isFavorite
                                // }),
                                onPressed: ()=>_toggleFavorite(),
                                color: Colors.red,
                                iconSize: 35,
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        widget.news.content.trim(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                left: 30,
                top: 40,
                child: IconButton(
                  onPressed: ()=>Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 35,
                    textDirection: TextDirection.ltr,
                  ),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}