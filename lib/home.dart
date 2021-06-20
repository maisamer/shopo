import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:shopo/custom_widget.dart';
import 'package:shopo/database/dbConnection.dart';
import 'package:shopo/model/Product.dart';
import 'package:shopo/shopping_cart.dart';

class Home extends StatefulWidget {
  BuildContext mContext;
  Home({Key key, @required this.mContext}) : super();
  @override
  _HomeState createState() => _HomeState(mContext);
}

class _HomeState extends State<Home> {
  Map<int, Product> choosenProduct = new HashMap();
  List<Product> products = [], listProducts = [];
  bool loading = true;
  getProducts() async {
    DBConnection db = DBConnection();
    db.getProductItems().then((value) => {
          setState(() {
            loading = false;
            products = value;
            _filteredProducts.addAll(products);
          })
        });
  }

  List<Product> _filteredProducts = [];
  int numberOfColumns = 2;
  Size size;
  _HomeState(BuildContext mContext) {
    searchBar = new SearchBar(
        hintText: 'search',
        onChanged: (input) {
          setState(() {
            _filteredProducts.clear();
            if (input == "") {
              _filteredProducts.addAll(products);
            } else {
              for (int i = 0; i < products.length; i++) {
                if (products[i]
                    .name
                    .toLowerCase()
                    .contains(input.toLowerCase())) {
                  _filteredProducts.add(products[i]);
                }
              }
            }
          });
        },
        onCleared: () {
          setState(() {
            _filteredProducts.clear();
            _filteredProducts.addAll(products);
          });
        },
        setState: setState,
        onSubmitted: print,
        buildDefaultAppBar: buildAppBar,
        inBar: false);
  }

  @override
  void initState() {
    // TODO: implement initState
    getProducts();
    super.initState();
  }

  SearchBar searchBar;
  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: <Widget>[
          GestureDetector(
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
            onTap: () {
              searchBar.beginSearch(context);
            },
          ),
          SizedBox(
            width: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              child: Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ),
              onTap: () {
                goToShoppingCart();
              },
            ),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfff4f4f8),
      appBar: searchBar.build(context),
      body: loading
          ? CustomWidget.buildSpinner(context)
          : products != null || products.length > 0
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildProductList(),
              )
              : buildEmptyCard(),
      drawer: buildDrawer(),
    );
  }

  Widget buildEmptyCard() {
    return Center(
      child: Text("There is no items"),
    );
  }

  Widget buildProductList() {
    return Column(
      children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: numberOfColumns,
            children: List.generate(_filteredProducts.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(top: 4, left: 6),
                child: buildProductItem(index),
              );
            }),
          ),
        )
      ],
    );
  }

  Widget buildProductItem(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: const Color(0x1f000000),
                offset: Offset(0, 1),
                blurRadius: 3,
                spreadRadius: 0)
          ],
          color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: 10,
          ),
          Image.asset(
            products[index].url,
            height: 70,
            width: 170,
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _filteredProducts[index].name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _filteredProducts[index].favorite =
                        !_filteredProducts[index].favorite;
                  });
                },
                child: Icon(
                  _filteredProducts[index].favorite
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: _filteredProducts[index].favorite
                      ? Colors.red
                      : Colors.black,
                  size: 22.0,
                ),
              )
            ],
          ),
          SizedBox(
            height: 1,
          ),
          Row(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_filteredProducts[index].price}EGB ${getKG(_filteredProducts[index].code)}'
                    ,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Color(0xFF0A8460),
                    size: 22.0,
                  ),
                  Text(
                    '4.9',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(6.0),
            child: ElevatedButton(
                child: Text(
                  'ADD TO CARD',
                  style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                onPressed: () {
                  addToCard(index);
                },
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.red))))),
          ),

        ],
      ),
    );
  }
  String getKG(String code){
    return code.contains('KG')?'/KG':'';
  }

  buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xfff4f4f8),
            ),
            child: Text('Welcome Guest'),
          ),
          ListTile(
            title: Text('Shopping Cart'),
            onTap: () {
              Navigator.pop(context);
              goToShoppingCart();
            },
          ),
        ],
      ),
    );
  }

  void goToShoppingCart() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShoppingCard(
              products: choosenProduct.entries.map((e) => e.value).toList()),
        ));
  }

  void addToCard(int index) {
    if (!choosenProduct.containsKey(index))
      choosenProduct[index] = products[index];
    choosenProduct[index].quantities++;
    showDialog(
        barrierDismissible: false,
        context: context,
        child: AlertDialog(
            content: Text("Item added successfully into the cart"),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]));
  }
}
