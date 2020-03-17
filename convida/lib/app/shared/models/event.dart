
class Event {
  String id;
  String name;
  String target;
  String address;
  String complement;
  String hrStart;
  String hrEnd;
  String dateStart;
  String dateEnd;
  String desc;
  String startSub;
  String endSub;
  String link;
  String type;
  String author;
  double lat;
  double lng;
  bool active;

  Event(
      {this.id,
        this.name,
        this.target,
        this.address,
        this.complement,
        this.hrStart,
        this.hrEnd,
        this.dateStart,
        this.dateEnd,
        this.desc,
        this.startSub,
        this.endSub,
        this.link,
        this.type,
        this.author,
        this.lat,
        this.lng,
        this.active});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    target = json['target'];
    address = json ['address'];
    complement = json ['complement'];
    hrStart = json['hrStart'];
    hrEnd = json ['hrEnd'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    desc = json['desc'];
    startSub = json['startSub'];
    endSub = json['endSub'];
    link = json['link'];
    type = json['type'];
    author = json['author'];
    lat = json['lat'];
    lng = json['lng'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['target'] = this.target;
    data['address'] = this.address;
    data['complement']  = this.complement;
    data['hrStart'] = this.hrStart;
    data['hrEnd'] = this.hrEnd;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    data['desc'] = this.desc;
    data['startSub'] = this.startSub;
    data['endSub'] = this.endSub;
    data['link'] = this.link;
    data['type'] = this.type;
    data['author'] = this.author;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['active'] = this.active;
    return data;
  }
}



