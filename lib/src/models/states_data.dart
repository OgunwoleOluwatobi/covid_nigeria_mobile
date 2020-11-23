class StatesData {
  String state;
  String totalConfirmedCases;
  String totalNewConfirmedCases;
  String totalDischargedCases;
  String totalNewDischargedCases;
  String totalDeaths;
  String totalNewDeaths;
  String totalActiveCases;
  String daysSinceLastReported;

  StatesData(
      {this.state,
      this.totalConfirmedCases,
      this.totalNewConfirmedCases,
      this.totalDischargedCases,
      this.totalNewDischargedCases,
      this.totalDeaths,
      this.totalNewDeaths,
      this.totalActiveCases,
      this.daysSinceLastReported});

  StatesData.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    totalConfirmedCases = json['totalConfirmedCases'];
    totalNewConfirmedCases = json['totalNewConfirmedCases'];
    totalDischargedCases = json['totalDischargedCases'];
    totalNewDischargedCases = json['totalNewDischargedCases'];
    totalDeaths = json['totalDeaths'];
    totalNewDeaths = json['totalNewDeaths'];
    totalActiveCases = json['totalActiveCases'];
    daysSinceLastReported = json['daysSinceLastReported'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['totalConfirmedCases'] = this.totalConfirmedCases;
    data['totalNewConfirmedCases'] = this.totalNewConfirmedCases;
    data['totalDischargedCases'] = this.totalDischargedCases;
    data['totalNewDischargedCases'] = this.totalNewDischargedCases;
    data['totalDeaths'] = this.totalDeaths;
    data['totalNewDeaths'] = this.totalNewDeaths;
    data['totalActiveCases'] = this.totalActiveCases;
    data['daysSinceLastReported'] = this.daysSinceLastReported;
    return data;
  }
}
