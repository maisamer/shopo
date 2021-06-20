import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopo/checkout.dart';
import 'package:shopo/custom_widget.dart';
import 'package:shopo/home.dart';
import 'package:shopo/model/Product.dart';

class ShoppingCard extends StatefulWidget {
  List<Product> products;
  ShoppingCard({Key key, this.products}) : super();
  @override
  _ShoppingCardState createState() => _ShoppingCardState();
}

class _ShoppingCardState extends State<ShoppingCard> {
  Size size;
  double totalAmount = 0;
  double discount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.products.forEach((element) {
      totalAmount += element.price*element.quantities;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: InkWell(
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ),
                    ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
          ),
          elevation: 2,
          title: Text("Shopping Cart",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.normal)),
        ),
        body: widget.products != null && widget.products.length != 0
            ? ListView(padding: EdgeInsets.all(20), children: [
                Column(
                  children: List.generate(widget.products.length,
                      (index) => buildShippingItem(index)),
                ),
                buildCardDetails(),
                SizedBox(
                  height: 20,
                ),
                buildButtons(context)
              ])
            : buildEmptyCard());
  }

  buildEmptyCard() {
    return Center(
      child: Text('There is no items in the shipping cart',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 20)),
    );
  }

  Widget buildShippingItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x1f000000),
                  offset: Offset(0, 1),
                  blurRadius: 5,
                  spreadRadius: 0)
            ],
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              widget.products[index].url,
              width: 60,
              height: 60,
            ),
            Column(
              children: [
                Text(widget.products[index].name,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 20)),
                SizedBox(
                  height: 2,
                ),
                Text(
                    '${widget.products[index].price * widget.products[index].quantities} EGP',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 15)),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  child: Text('REMOVE',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w300,
                          fontSize: 12)),
                  onTap: () {
                    removeItem(index);
                  },
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Colors.grey[400]),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x1f000000),
                        offset: Offset(0, 1),
                        blurRadius: 5,
                        spreadRadius: 0)
                  ],
                  color: Colors.white),
              child: Column(
                children: [
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text('+',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 20)),
                    ),
                    onTap: () {
                      setState(() {
                        totalAmount += widget.products[index].price;
                        widget.products[index].quantities++;
                      });
                    },
                  ),
                  Text('${widget.products[index].quantities}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 18)),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text('-',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 20)),
                    ),
                    onTap: () {
                      if (widget.products[index].quantities - 1 <= 0)
                        removeItem(index);
                      else
                        setState(() {
                          widget.products[index].quantities--;
                          totalAmount -= widget.products[index].price;
                        });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void removeItem(int index) {
    setState(() {
      totalAmount -=
          widget.products[index].price * widget.products[index].quantities;
      widget.products.removeAt(index);
    });
  }

  Widget buildCardDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Text('Cart Details',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 15)),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Amount',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 15)),
            Text('$totalAmount EGP',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Discount',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 15)),
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Text(
                '$discount',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            width: size.width * 0.9,
            height: 1,
            decoration: BoxDecoration(color: Colors.grey[300])),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Final Amount',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 15)),
            Text('${totalAmount - discount} EGP',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 15)),
          ],
        ),
      ],
    );
  }

  Widget buildButtons(BuildContext context) {
    return Column(
      children: [
        CustomWidget.buildButton(context, goToCheckout,
            size: size.width * 0.9, title: 'BILL TO/SHIP TO'),
        SizedBox(
          height: 8,
        ),
        CustomWidget.buildButton(context, goToCheckout,
            size: size.width * 0.9,
            title: 'CHECKOUT',
            backgroundColor: Colors.green[900],
            fontColor: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  void goToCheckout(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Checkout(products: widget.products,totalAmount: totalAmount,),
        ));
  }
}
