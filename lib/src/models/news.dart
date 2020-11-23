class News {
  String postUrl;
  String imgLink;
  String headline;

  News({this.postUrl, this.imgLink, this.headline});

  News.fromJson(Map<String, dynamic> json) {
    postUrl = json['postUrl'];
    imgLink = json['imgLink'];
    headline = json['headline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postUrl'] = this.postUrl;
    data['imgLink'] = this.imgLink;
    data['headline'] = this.headline;
    return data;
  }
}
