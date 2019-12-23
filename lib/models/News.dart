class News{
  final String title;
  final String content;
  final String time;
  final String link;
  final String imgUrl;
  final String tag;

  News({this.title,this.content,this.time,this.link,this.imgUrl,this.tag});

  factory News.fromJson(Map<String,dynamic> json){
    return News(
      title: json["title"],
      content: json["content"],
      time:json["time"],
      link: json["link"],
      imgUrl: json["img_path"],
      tag: json["tag"]
    );
  }
}

class LoveNews{
  static List<News> loveNewsList = [];
}