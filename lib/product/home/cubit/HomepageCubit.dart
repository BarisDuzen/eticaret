import 'package:eticaret/data/repo/GetRepo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eticaret/Products.dart';

class HomeCubit extends Cubit<List<Products>> {

  HomeCubit() : super([]);

  GetRepo repo=GetRepo();

  Future<void> fetchProducts() async {
    try {
      final products = await repo.fetchProducts();
      emit(products);
    } catch (e) {
      emit([]);
      debugPrint("Cubit API Hatası: $e");
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      fetchProducts();
      return;
    }
    final filtered = await repo.searchProducts(query);
    emit(filtered);
  }

}