import 'package:flutter/material.dart';
import './screens/products_overview/products_overview_screen.dart';
import './screens/product_details/product_details_screen.dart';
import 'package:provider/provider.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './screens/cart/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders/ordersScreen.dart';
import './screens/user_products/user_products_screen.dart';
import './screens/edit_product/edit_product_screen.dart';
import './screens/auth_screen/4.1 auth_screen.dart';
import './providers/auth.dart';
import './16.3 splash_screen.dart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: (_) => Products(),
              update: (ctx, auth, previousProducts) {
                return previousProducts
                  ..setAuthToken = auth.token
                  ..setUserId = auth.userId;
              }),
          ChangeNotifierProvider<Cart>.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders(),
            update: (ctx, auth, previousOrders) => previousOrders
              ..setAuthToken = auth.token
              ..setUserId = auth.userId,
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.amber,
              accentColor: Colors.amberAccent,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogIn(),
                    builder: (ctx, snap) =>
                        snap.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              // '/': (context) => ProductsOverviewScreen(),
              ProductDetalisScreen.routeId: (context) => ProductDetalisScreen(),
              CartScreen.routeId: (context) => CartScreen(),
              OrdersScreen.routeId: (context) => OrdersScreen(),
              UserProductsScreen.routId: (context) => UserProductsScreen(),
              EditProductScreen.routeId: (context) => EditProductScreen(),
              // AuthScreen.routeName: (context) => AuthScreen()
            },
          ),
        ));
  }
}
