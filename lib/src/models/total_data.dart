class TotalData {
  String overallConfirmedCases;
  String overallNewConfirmedCases;
  String overallDischargedCases;
  String overallNewDischargedCases;
  String overallDeaths;
  String overallNewDeaths;
  String overallActiveCases;

  TotalData(
      {this.overallConfirmedCases,
      this.overallNewConfirmedCases,
      this.overallDischargedCases,
      this.overallNewDischargedCases,
      this.overallDeaths,
      this.overallNewDeaths,
      this.overallActiveCases});

  TotalData.fromJson(Map<String, dynamic> json) {
    overallConfirmedCases = json['overallConfirmedCases'];
    overallNewConfirmedCases = json['overallNewConfirmedCases'];
    overallDischargedCases = json['overallDischargedCases'];
    overallNewDischargedCases = json['overallNewDischargedCases'];
    overallDeaths = json['overallDeaths'];
    overallNewDeaths = json['overallNewDeaths'];
    overallActiveCases = json['overallActiveCases'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['overallConfirmedCases'] = this.overallConfirmedCases;
    data['overallNewConfirmedCases'] = this.overallNewConfirmedCases;
    data['overallDischargedCases'] = this.overallDischargedCases;
    data['overallNewDischargedCases'] = this.overallNewDischargedCases;
    data['overallDeaths'] = this.overallDeaths;
    data['overallNewDeaths'] = this.overallNewDeaths;
    data['overallActiveCases'] = this.overallActiveCases;
    return data;
  }
}
