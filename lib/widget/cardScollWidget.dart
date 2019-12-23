import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_platform/widget/StaticData.dart';

class CardScollWidget extends StatelessWidget{
  final currentPage;
  final padding = 20.0;
  final verticalInset = 20.0;
  final cardAspectionRation = 9/16.0;
  final widgetAspectRatio =(9/16.0)*1.2;
  final newsList;

  CardScollWidget(this.currentPage,this.newsList);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(
        builder: (context,contraints){
          var width = contraints.maxWidth;
          var height = contraints.maxHeight;

          var safeWidth = width-2*padding;
          var safeheight = height-2*padding;
          
          var heightOfPrimaryCard = safeheight;
          var widthOfPrimaryCard = heightOfPrimaryCard*cardAspectionRation;

          var primaryCardLeft = safeWidth - widthOfPrimaryCard;
          var horizontalInset = primaryCardLeft/2;
          
          List<Widget> cardList = new List();
          for(var i=0;i<newsList.length;i++){
            var delta = i-currentPage;
            bool isOnRight = delta>0;
            var start = padding+max(primaryCardLeft-horizontalInset*-delta*(isOnRight?15:1),0.0);

            var cardItem = Positioned.directional(
              top: padding+verticalInset*max(-delta,0),
              bottom: padding+verticalInset*max(-delta,0),
              start: start,
              textDirection: TextDirection.rtl,
              child: Container(
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.black54,width: 1),
                //   borderRadius: BorderRadius.circular(20)
                // ),
                child: AspectRatio(
                  aspectRatio: cardAspectionRation,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Hero(
                        tag: newsList[i].imgUrl,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: serverImageLink+newsList[i].imgUrl.substring(6),
                            placeholder: (context, url) => Center(child:CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Center(child: Icon(Icons.error,size: 100,color: Colors.amberAccent,),),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                          child: Text(
                            newsList[i].title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              background: Paint()..color = Colors.black26,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
            cardList.add(cardItem);
          }
          return Stack(
            children: cardList,
          );
        },
      ),
    );
  }
}