import 'dart:math';

import 'package:mysql1/mysql1.dart';
import 'package:shopo/model/Product.dart';
import 'package:shopo/model/Customer.dart';
import 'package:shopo/model/order.dart';

class DBConnection {
  Future<List<Product>> getProductItems() async {
    List<Product> productList = [];
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '10.0.2.2',
        port: 3306,
        user: 'root',
        db: 'shopo',
        password: 'password',
      ));
      // Query the database using a parameterized query
      var results = await conn.query('select * from str_items');
      for (var row in results)
        productList.add(
            Product(id:row[0],code: row[1], name: row[2], price: row[4], url: row[9]));

      await conn.close();
    } catch (exception) {
      print(exception);
    }
    return productList;
  }

  Future<List<Customer>> getCustomers() async {
    List<Customer> custmersList = [];
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '10.0.2.2',
        port: 3306,
        user: 'root',
        db: 'shopo',
        password: 'password',
      ));
      // Query the database using a parameterized query
      var results = await conn.query('select * from sal_customers');
      for (var row in results)
        custmersList.add(Customer(id: row[0], name: row[2], code: row[1]));

      await conn.close();
    } catch (exception) {
      print(exception);
    }
    return custmersList;
  }

  Future<void> saveOrder(Order order) async {
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '10.0.2.2',
        port: 3306,
        user: 'root',
        db: 'shopo',
        password: 'password',
      ));
      var id = new DateTime.now().millisecondsSinceEpoch;
      var card = await conn.query(
          'insert into sal_shopping_carts (CART_ID,USER_ID,CUSTOMER_ID, SHIP_CUSTOMER_ID, SHIP_ADDRESS ,TOTAL_DISCOUNT,TOTAL_AMOUNT,BILL_CUSTOMER_ID,BILL_ADDRESS ) values (?, ?, ?,?,?,?,?,?,?)',
          [id,order.shipToCode ,order.shipToCode,order.shipToCode ,order.billToAddress,0,order.totalAmount,order.billToCode,order.billToAddress]);
      // Query the database using a parameterized query
      await order.products.forEach((element) async {
        Random random = new Random();
        int randomNumber = random.nextInt(100);
        var itemId = new DateTime.now().millisecondsSinceEpoch+randomNumber;
        await conn.query('insert into sal_shopping_cart_items (SHOPPING_ID, CART_ID, ITEM_ID,PRICE,ORDERED_QTY) values (?, ?, ?,?,?)',
            [itemId, id ,element.id,element.price,element.quantities ]);
      });
    } catch (exception) {
      print(exception);
    }
  }
}
