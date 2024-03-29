import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:life_style_app/shop/order_view.dart';

class CartView extends StatelessWidget {
  final String? cartKey;
  const CartView({Key? key, this.cartKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late List orders = [];
    var keys;
    Future getCartItems() async {
      final url = 'http://nutriana.surnaturel.ma/wp-json/cocart/v1/get-cart?cart_key=$cartKey';
      final response = await http.get(Uri.parse(url), headers: {"Accept": "application/json"});
      if (response.statusCode == 200) {
        var decoded = json.decode(response.body);
        keys = decoded.keys.toList();
        return decoded;
      } else {
        print("ERROR GETTING CART");
        return null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("YOUR CART"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderView(orders: orders)));
              },
              child: Text(
                "Proceed",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: FutureBuilder(
        future: getCartItems(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = {
                  'product_id': snapshot.data[keys[index].toString()]['product_id'].toString(),
                  'quantity': snapshot.data[keys[index].toString()]['quantity'].toString()
                };
                orders.add(data);
                var title = snapshot.data[keys[index].toString()]['product_title'].toString();
                var subtitle = snapshot.data[keys[index].toString()]['product_price'].toString();
                return ListTile(
                  leading: Icon(Icons.production_quantity_limits),
                  title: Text(title),
                  subtitle: Text("Price: " + subtitle),
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
