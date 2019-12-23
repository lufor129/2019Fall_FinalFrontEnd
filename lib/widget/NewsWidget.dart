import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_platform/screen/NewsScreen.dart';
import 'package:news_platform/widget/StaticData.dart';

class NewsWidget extends StatelessWidget{
  final news;

  NewsWidget({this.news});

  @override
  Widget build(BuildContext context) {
        return InkWell(
      onTap: ()=>Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewsScreen(news: news)
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              offset: Offset(0, 4),
              blurRadius: 10
            )
          ]
        ),
        width: double.infinity,
        height: 200,
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: news.imgUrl,
              child: CachedNetworkImage(
                imageUrl: serverImageLink+news.imgUrl.substring(6),
                placeholder: (context, url) => Center(child:CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error,color: Colors.amberAccent,size: 45),
                imageBuilder: (context,imageProvider) => Container(
                  height: 200,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(50),bottomLeft: Radius.circular(50)),
                      image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  )
                )
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,  
                  children: <Widget>[
                    Text(
                      news.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      news.time.replaceAll("_", " ")
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.amberAccent
                      ),
                      child: Text(
                        news.tag,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}