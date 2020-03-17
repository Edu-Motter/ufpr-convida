class Report {
  String grr;
  String report;


  Report({this.grr, this.report});

  Report.fromJson(Map<String, dynamic> json) {
    grr = json['grr'];
    report = json['report'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grr'] = this.grr;
    data['report'] = this.report;
    return data;
  }
}