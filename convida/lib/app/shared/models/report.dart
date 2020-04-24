class Report {
  String grr;
  String report;
  bool ignored;
  String id;

  Report({this.grr, this.report, this.ignored});

  Report.fromJson(Map<String, dynamic> json) {
    grr = json['grr'];
    report = json['report'];
    ignored = json['ignored'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grr'] = this.grr;
    data['report'] = this.report;
    data['ignored'] = this.ignored;
    data['id'] = this.id;
    return data;
  }
}