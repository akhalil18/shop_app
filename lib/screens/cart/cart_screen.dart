import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart.dart' show Cart;
import './cart_list.dart';
import '../../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeId = '/Cart-screen';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    List cartDataList = cartData.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 2.0,
            margin: const EdgeInsets.all(15.0),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$' + cartData.totalPrice.toStringAsFixed(1),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  OrderButton(cartData: cartData, cartDataList: cartDataList),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartData.itemCount,
              itemBuilder: (context, i) => CartList(
                cartDataList[i].id,
                cartDataList[i].price,
                cartDataList[i].quantity,
                cartDataList[i].title,
                cartData.deleteItem,
                // cartData.items.keys.toList()[i],  //convert cart items to list and get the key(productId)
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartData,
    @required this.cartDataList,
  }) : super(key: key);

  final Cart cartData;
  final List cartDataList;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Order Now',
              style: TextStyle(color: Colors.red),
            ),
      onPressed: (widget.cartData.itemCount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cartData.totalPrice,
                widget.cartDataList,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cartData.clearCart();
            },
    );
  }
}
