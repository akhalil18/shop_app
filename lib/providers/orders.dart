import 'package:flutter/foundation.dart';
import 'dart:convert';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double orderCost;
  final DateTime dateTime;
  final List<CartItem> products;
  OrderItem({
    @required this.id,
    @required this.orderCost,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  String authToken;
  String userId;
  List<OrderItem> _orders = [];

  set setAuthToken(String authToken) {
    this.authToken = authToken;
  }

  set setUserId(String userId) {
    this.userId = userId;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url =
        'https://my-shop-9e2c2.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    List<OrderItem> fetchedOrders = [];
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, order) {
      fetchedOrders.add(OrderItem(
        id: orderId,
        orderCost: order['orderCost'],
        dateTime: DateTime.parse(order['dateTime']),
        products: (order['products'] as List<dynamic>)
            .map((prod) => CartItem(
                  id: prod['id'],
                  price: prod['price'],
                  quantity: prod['quantity'],
                  title: prod['title'],
                ))
            .toList(),
      ));
    });
    _orders = fetchedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(double totalCost, List<CartItem> cartProducts) async {
    final dateTime = DateTime.now();
    final oldOrders = _orders;
    final url =
        'https://my-shop-9e2c2.firebaseio.com/orders/$userId.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'orderCost': totalCost,
          'dateTime': dateTime.toIso8601String(),
          'products': cartProducts
              .map((product) => {
                    'id': product.id,
                    'title': product.title,
                    'quantity': product.quantity,
                    'price': product.price,
                  })
              .toList(),
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          orderCost: totalCost,
          dateTime: dateTime,
          products: cartProducts,
        ),
      );
      if (response.statusCode >= 400) {
        _orders = oldOrders;
      }
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }
}
