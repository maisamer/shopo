import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopo/custom_widget.dart';
import 'package:shopo/database/dbConnection.dart';
import 'package:shopo/home.dart';
import 'package:shopo/model/Product.dart';
import 'package:shopo/model/order.dart';
import 'package:shopo/model/Customer.dart';

class Checkout extends StatefulWidget {
  List<Product> products;
  double totalAmount;
  Checkout({Key key, @required this.products, @required this.totalAmount})
      : super();
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final _formKey = GlobalKey<FormState>();
  Size size;
  Customer _billToName, _shipToName;
  final _billToAddressController = TextEditingController();
  final _shipToAddressController = TextEditingController();
  DBConnection db = DBConnection();
  List<Customer> customers = [];

  @override
  void initState() {
    // TODO: implement initState
    getConsumers();
    super.initState();
  }

  getConsumers() {
    db.getCustomers().then((value) => {
          setState(() {
            customers = value;
          })
        });
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: Text("Bill To/Ship To",
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal)),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: <Widget>[
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
        appBar: buildAppBar(context),
        drawer: buildDrawer(),
        body: ListView(
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Builder(
                  builder: (BuildContext context) {
                    return Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bill to',
                              style: TextStyle(
                                  color: Color(0xFF0A8460),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Name',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: 9,
                            ),
                            buildDropDownMenu(saveBillToName, _billToName),
                            SizedBox(
                              height: 20,
                            ),
                            CustomWidget.buildFormInputText(
                                controller: _billToAddressController,
                                errorMessage:
                                    "Bill to address Field is required",
                                label: "Address"),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Ship to',
                              style: TextStyle(
                                  color: Color(0xFF0A8460),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Name',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: 9,
                            ),
                            buildDropDownMenu(saveShipToName, _shipToName),
                            SizedBox(
                              height: 30,
                            ),
                            CustomWidget.buildFormInputText(
                                controller: _shipToAddressController,
                                errorMessage:
                                    "Ship to address Field is required",
                                label: "Address"),
                            SizedBox(
                              height: 40,
                            ),
                            CustomWidget.buildButton(context, checkout,
                                size: size.width * 0.88,
                                title: 'CONTINUE',
                                backgroundColor: Color(0xFF0A8460),
                                fontColor: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 18),
                          ],
                        ),
                      ),
                    );
                  },
                ))
          ],
        ));
  }

  void checkout(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      if (_shipToName == null) {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Please choose ship to customer name')));
      } else if (_billToName == null) {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Please choose bill to customer name')));
      } else {
        _formKey.currentState.save();
        Order order = Order(
            billToCode: _billToName.id,
            shipToCode: _shipToName.id,
            billToAddress: _billToAddressController.text,
            shipToAddress: _shipToAddressController.text,
            products: widget.products,
            totalAmount: widget.totalAmount);
        db.saveOrder(order).then((value) => {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  child: AlertDialog(
                      content: Text("Congratulation You finished your order thanks for using our service"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Done"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ));
                          },
                        ),
                      ]))
            });
      }
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Please enter valid data')));
    }
  }

  Widget buildDropDownMenu(Function onChange, Customer value) {
    return Container(
      padding: EdgeInsets.only(top: 3, bottom: 8, right: 10, left: 10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton<Customer>(
        value: value,
        icon: RotatedBox(
          child: Icon(
            Icons.arrow_back_ios,
            color: const Color(0xFF0A8460),
          ),
          quarterTurns: 135,
        ),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        style: const TextStyle(color: Colors.black),
        underline: SizedBox(),
        onChanged: (Customer newValue) {
          onChange(newValue);
        },
        items: customers.map<DropdownMenuItem<Customer>>((Customer value) {
          return DropdownMenuItem<Customer>(
            value: value,
            child: Text(value.name),
          );
        }).toList(),
      ),
    );
  }

  void saveBillToName(Customer newValue) {
    setState(() {
      _billToName = newValue;
    });
  }

  void saveShipToName(Customer newValue) {
    setState(() {
      _shipToName = newValue;
    });
  }

  Widget buildDrawer() {
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
    Navigator.pop(context);
  }
}
