import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final items = await localDataSource.getCartItems();
      return Right(items);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(CartItem item) async {
    try {
      final currentItems = await localDataSource.getCartItems();
      final existingIndex = currentItems.indexWhere(
        (cartItem) => cartItem.product.id == item.product.id,
      );

      if (existingIndex != -1) {
        currentItems[existingIndex] = CartItemModel(
          product: item.product,
          quantity: currentItems[existingIndex].quantity + item.quantity,
        );
      } else {
        currentItems.add(
          CartItemModel(product: item.product, quantity: item.quantity),
        );
      }

      await localDataSource.saveCartItems(currentItems);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(int productId) async {
    try {
      final currentItems = await localDataSource.getCartItems();
      currentItems.removeWhere((item) => item.product.id == productId);
      await localDataSource.saveCartItems(currentItems);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateQuantity(
    int productId,
    int quantity,
  ) async {
    try {
      final currentItems = await localDataSource.getCartItems();
      final index = currentItems.indexWhere(
        (item) => item.product.id == productId,
      );

      if (index != -1) {
        if (quantity <= 0) {
          currentItems.removeAt(index);
        } else {
          currentItems[index] = CartItemModel(
            product: currentItems[index].product,
            quantity: quantity,
          );
        }
        await localDataSource.saveCartItems(currentItems);
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
