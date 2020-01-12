import 'package:flutter/material.dart';
import '../../providers/products_provider.dart';
import '../../app_drawer.dart';
import 'package:provider/provider.dart';
import './user_product_item.dart';
import '../../screens/edit_product/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routId = '/user-products-screen';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    // final myProducts = productsData.items;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('My Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeId);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, proSnap) =>
            proSnap.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (context, i) => UserProductItem(
                              productsData.items[i].imageUrl,
                              productsData.items[i].title,
                              productsData.items[i].id),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
