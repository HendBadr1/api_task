import 'package:dio/dio.dart';

Future<List<dynamic>> fetchProducts() async {
  final dio = Dio();
  final response = await dio.get("https://fakestoreapi.com/products/category/jewelery");

  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception("Error while loading");
  }
}