import 'package:flutter/material.dart';
import 'package:news_platform/models/News.dart';
import 'package:news_platform/widget/StaticData.dart';
import 'package:requests/requests.dart';

class FeedbackScreen extends StatefulWidget{
  final searchText;
  final List<News> newslist;
  final List<Object> newsLabel;

  FeedbackScreen({this.searchText,this.newslist,this.newsLabel});
  FeedbackScreenState createState()=>FeedbackScreenState();
}

class FeedbackScreenState extends State<FeedbackScreen>{

  List<Object> newsLabel;
  bool isWaiting = false;

  @override
  void initState() {
    super.initState();
    newsLabel = widget.newsLabel;
  }

  void _pushFeedback() async{
    setState(() {
      isWaiting = true;
    });
    List ls = [];
    for(int i=0;i<newsLabel.length;i++){
      ls.add(
        {"sentA":widget.searchText,"sentB":widget.newslist[i].title,"label":newsLabel[i]}
      );
    }
    Response response = await Requests.post(
      serverLink+"/pushFeedback",
      body: {
        "data":ls
      },
      bodyEncoding: RequestBodyEncoding.JSON
    );
    print(response.content());
    Future.delayed(const Duration(milliseconds: 1500),(){
      setState(() {    
        isWaiting = false;
      });
    });
  }

  List<Widget> _radioColumn(){
    List<Widget> ls = [];
    widget.newslist.asMap().forEach((index,data)=>
      ls.add(
        Container(
          padding: EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black26,
                width: 1
              )
            )
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 2),
                  child: Text(
                    data.title,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )
                ),
              ),
              Expanded(
                flex: 2,
                child: new Radio(
                  value: "disagreed",
                  groupValue: newsLabel[index],
                  activeColor: Colors.red,
                  onChanged: (v){
                    setState(() {
                      newsLabel[index]=v;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: new Radio(
                  value: "unrelated",
                  groupValue: newsLabel[index],
                  activeColor: Colors.red,
                  onChanged: (v){
                    setState(() {
                      newsLabel[index]=v;
                    });
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: new Radio(
                  value: "agreed",
                  groupValue: newsLabel[index],
                  activeColor: Colors.red,
                  onChanged: (v){
                    setState(() {
                      newsLabel[index]=v;
                    });
                  },
                ),
              )
            ],
          ),
        )
      )
    );
    return ls;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: ()=>Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Text(
                    widget.searchText,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "disagree",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "unrelated",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "  agreed",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _radioColumn()
                ) 
              ),
            ),
            Container(
              child:isWaiting==true? Center(
                child: CircularProgressIndicator(),
              ) 
              :IconButton(
                icon: Icon(
                  Icons.check,
                  size: 32,
                  color: Colors.cyan,
                ),
                onPressed: (){
                  _pushFeedback();
                  Navigator.pop(context);
                },
              )
            )
          ],
        ),
      )
    );
  }
}