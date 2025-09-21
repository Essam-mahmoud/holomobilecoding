import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final getProducts = ref.read(getProductsUseCaseProvider);
  final result = await getProducts(NoParams());

  return result.fold(
    (failure) => throw Exception(failure.message),
    (products) => products,
  );
});

final productDetailsProvider = FutureProvider.family<Product, int>((
  ref,
  id,
) async {
  final getProductDetails = ref.read(getProductDetailsUseCaseProvider);
  final result = await getProductDetails(id);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (product) => product,
  );
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.read(productsRepositoryProvider);
  final result = await repository.getCategories();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (categories) => ['all', ...categories],
  );
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'all');

final filteredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final repository = ref.read(productsRepositoryProvider);

  if (selectedCategory == 'all') {
    final result = await repository.getProducts();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (products) => products,
    );
  } else {
    final result = await repository.getProductsByCategory(selectedCategory);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (products) => products,
    );
  }
});
