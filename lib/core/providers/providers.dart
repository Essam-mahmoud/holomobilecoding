import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';
import '../../features/products/data/datasources/products_remote_data_source.dart';
import '../../features/products/data/repositories/products_repository_impl.dart';
import '../../features/products/domain/repositories/products_repository.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/domain/usecases/get_product_details.dart';
import '../../features/cart/data/datasources/cart_local_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';

// Core providers
final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

// Products providers
final productsRemoteDataSourceProvider = Provider<ProductsRemoteDataSource>((
  ref,
) {
  return ProductsRemoteDataSourceImpl(apiClient: ref.read(apiClientProvider));
});

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepositoryImpl(
    remoteDataSource: ref.read(productsRemoteDataSourceProvider),
  );
});

final getProductsUseCaseProvider = Provider<GetProducts>((ref) {
  return GetProducts(ref.read(productsRepositoryProvider));
});

final getProductDetailsUseCaseProvider = Provider<GetProductDetails>((ref) {
  return GetProductDetails(ref.read(productsRepositoryProvider));
});

// Cart providers - Fixed to handle async SharedPreferences properly
final cartLocalDataSourceProvider = FutureProvider<CartLocalDataSource>((
  ref,
) async {
  final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
  return CartLocalDataSourceImpl(sharedPreferences: sharedPreferences);
});

final cartRepositoryProvider = FutureProvider<CartRepository>((ref) async {
  final localDataSource = await ref.watch(cartLocalDataSourceProvider.future);
  return CartRepositoryImpl(localDataSource: localDataSource);
});
