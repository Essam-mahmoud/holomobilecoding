import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class CartNotifier extends AsyncNotifier<List<CartItem>> {
  late CartRepository _cartRepository;

  @override
  Future<List<CartItem>> build() async {
    // Wait for cart repository to be ready
    _cartRepository = await ref.watch(cartRepositoryProvider.future);
    return await _loadCartItems();
  }

  Future<List<CartItem>> _loadCartItems() async {
    final result = await _cartRepository.getCartItems();
    return result.fold((failure) => <CartItem>[], (items) => items);
  }

  Future<void> addToCart(CartItem item) async {
    state = const AsyncLoading();
    final result = await _cartRepository.addToCart(item);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) async => state = AsyncData(await _loadCartItems()),
    );
  }

  Future<void> removeFromCart(int productId) async {
    state = const AsyncLoading();
    final result = await _cartRepository.removeFromCart(productId);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) async => state = AsyncData(await _loadCartItems()),
    );
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    state = const AsyncLoading();
    final result = await _cartRepository.updateQuantity(productId, quantity);
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) async => state = AsyncData(await _loadCartItems()),
    );
  }

  Future<void> clearCart() async {
    state = const AsyncLoading();
    final result = await _cartRepository.clearCart();
    result.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) => state = const AsyncData([]),
    );
  }

  double get totalAmount {
    return state.when(
      data:
          (items) => items.fold(0.0, (total, item) => total + item.totalPrice),
      loading: () => 0.0,
      error: (_, __) => 0.0,
    );
  }

  int get totalItems {
    return state.when(
      data: (items) => items.fold(0, (total, item) => total + item.quantity),
      loading: () => 0,
      error: (_, __) => 0,
    );
  }
}

final cartProvider = AsyncNotifierProvider<CartNotifier, List<CartItem>>(
  () => CartNotifier(),
);
