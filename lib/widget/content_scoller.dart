import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_platform/models/News.dart';
import 'package:news_platform/screen/NewsScreen.dart';
import 'package:news_platform/widget/StaticData.dart';

class ContentScroll extends StatelessWidget{

  final List<News> newList;
  final String title;
  final double imageHeight;
  final double imageWidth;
  final bool needIcon;

  ContentScroll({this.newList,this.title,this.imageHeight,this.imageWidth,this.needIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                )
              ),
            ],
          ),
        ),
        Container(
          height: imageHeight,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 30),
            scrollDirection: Axis.horizontal,
            itemCount: newList.length,
            itemBuilder: (BuildContext context,int index){
              return InkWell(
                onTap: ()=> Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:(_)=>NewsScreen(news: newList[index])
                  )
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20
                    ),
                    width: imageWidth,
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
                          imageUrl: serverImageLink+newList[index].imgUrl.substring(6),
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
    );
  }
}