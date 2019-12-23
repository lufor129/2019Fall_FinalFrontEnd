class Candidate{
  final String imageUrl;
  final String title;
  final String description;
  final String importP;
  final int congressSeat;
  final String code;

  Candidate({
    this.imageUrl,
    this.title,
    this.description,
    this.importP,
    this.congressSeat,
    this.code
  });
}

final List<Candidate> candidates = [
  Candidate(
    imageUrl: "assets/images/TPP.jpg",
    title: "臺灣民眾黨",
    description: "政治不難，回收而已!!",
    importP: "柯文哲",
    congressSeat: 0,
    code: "TPP"
  ),
  Candidate(
    imageUrl: "assets/images/KMT.jpg",
    title: "中國國民黨",
    description: "我現在要出征♫ ♪~ 我現在要出征♫ ♪~",
    importP: "韓國瑜",
    congressSeat: 35,
    code: "KMT"
  ),
  Candidate(
    imageUrl: "assets/images/DPP.jpg",
    title: "民主進步黨",
    description: "不要想用小黨來監督大黨!!",
    importP: "蔡英文",
    congressSeat: 69,
    code: "DPP"
  ),
  Candidate(
    imageUrl: "assets/images/NPP.jpg",
    title: "時代力量黨",
    description: "小綠出去，時力發財!!",
    importP: "黃國昌",
    congressSeat: 3,
    code:"NPP"
  )
];