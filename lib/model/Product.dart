class Product{
  var id;
  String name;
  String url;
  int quantities;
  double price;
  bool favorite = false;
  String code;

  Product({this.id,this.name, this.url, this.quantities=0, this.price,this.code,this.favorite=false});

  Product.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        url = json['url'],
        quantities = json['quantities'],
        price = json['price'],
        code = json['code'];
  Map<String, dynamic> toJson() => {
    'name': name,
    'url': url,
    'quantities':quantities,
    'price':price,
    'code':code,
  };
}