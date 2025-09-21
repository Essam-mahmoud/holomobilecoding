import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../products/data/models/product_model.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> cartItems);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final jsonString = sharedPreferences.getString(AppConstants.cartKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) {
          return CartItemModel(
            product: ProductModel.fromJson(json['product']),
            quantity: json['quantity'] as int,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      throw CacheException('Failed to load cart items: ${e.toString()}');
    }
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> cartItems) async {
    try {
      final jsonList =
          cartItems
              .map(
                (item) => {
                  'product': {
                    'id': item.product.id,
                    'title': item.product.title,
                    'price': item.product.price,
                    'description': item.product.description,
                    'category': item.product.category,
                    'image': item.product.image,
                  },
                  'quantity': item.quantity,
                },
              )
              .toList();

      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(AppConstants.cartKey, jsonString);
    } catch (e) {
      throw CacheException('Failed to save cart items: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await sharedPreferences.remove(AppConstants.cartKey);
    } catch (e) {
      throw CacheException('Failed to clear cart: ${e.toString()}');
    }
  }
}
