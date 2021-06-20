import 'package:shopo/model/Product.dart';

class Order{
  int billToCode;
  int shipToCode;
  String billToAddress;
  String shipToAddress;
  List<Product> products;
  double totalAmount;

  Order({this.billToCode, this.shipToCode, this.billToAddress,
      this.shipToAddress, this.products,this.totalAmount});
}