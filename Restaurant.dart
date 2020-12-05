class Restaurant {
  String name,
      addressLine1,
      addressLine2,
      city,
      phoneNo,
      mailid,
      imgs,
      review,
      id,
      reviewCount;
  Restaurant(
      {this.name,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.phoneNo,
      this.mailid,
      this.imgs,
      this.review,
      this.id,
      this.reviewCount});
  factory Restaurant.fromJson(Map<String, dynamic> parsedJson) {
    return Restaurant(
      name: parsedJson["restaurant_name"] as String,
      addressLine1: parsedJson["addressl1"] as String,
      addressLine2: parsedJson["addressl2"] as String,
      city: parsedJson["city"] as String,
      phoneNo: parsedJson["phone_no"] as String,
      mailid: parsedJson["restaurant_email"] as String,
      imgs: parsedJson["img_links"] as String,
      review: parsedJson["overall_review"] as String,
      id: parsedJson["restaurant_id"] as String,
      reviewCount: parsedJson['review_count'] as String,
    );
  }
}

class City {
  String name;
  City({this.name});
  factory City.fromJson(Map<String, dynamic> parsedJson) {
    return City(name: parsedJson["city"] as String);
  }
}

class ScreenArguments {
  static String name = "";
  static int coins = 0;
  static Restaurant res;
}
