import 'package:convida/app/shared/models/event.dart';

class User {
  String grr;
  String name;
  String lastName;
  String password;
  String email;
  String birth;
  bool adm;
  List<Event> fav;

  User({this.name, this.lastName, this.grr, this.email, this.password, this.birth, this.adm,this.fav});

  //! Start to use this constructor:
  User.fromJsonWithoutFavorites(Map<String, dynamic> json) {
    name = json['name'];
    lastName = json['lastName'];
    grr = json['grr'];
    email = json['email'];
    birth = json['birth'];
    adm = json['adm'];
    password = json['password'];
  }

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lastName = json['lastName'];
    grr = json['grr'];
    email = json['email'];
    birth = json['birth'];
    adm = json['adm'];
    password = json['password'];
    try {
      fav = new List<Event>();
      json['fav'].forEach((v) {
        fav.add(new Event.fromJson(v));
      });
    } catch (e) {
      print("User without favorites events!");
      fav = [];
    }
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['grr'] = this.grr;
    data['email'] = this.email;
    data['birth'] = this.birth;
    data['adm'] = this.adm;
    data['password'] = this.password;
    if (this.fav != null) {
      data['fav'] = this.fav.map((v) => v.toJson()).toList();
    }
    return data;
  }
}