class DataModel{
  String? tokenName;
  String? tokenLogo;
  double? usdPrice;

  DataModel.fromJson(Map<String,dynamic> json)
      : tokenName = json['tokenName'],
        tokenLogo=json['tokenLogo'],
        usdPrice=json['usdPrice'];

  //a method that convert object to json
  Map<String, dynamic> toJson() => {
    'name': tokenName,
    'logo_url': tokenLogo,
    'current_price':usdPrice
  };

}