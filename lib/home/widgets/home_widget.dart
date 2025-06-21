import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({super.key});

  Future<List<dynamic>> fetchProducts() async {
    final dio = Dio();
    final response = await dio.get("https://fakestoreapi.com/products/category/jewelery");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("Error while loading");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("All Jewelry Info"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.network(
                            product["image"],
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(" ID: ${product["id"]}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(" Title: ${product["title"]}"),
                        const SizedBox(height: 5),
                        Text(" Price: \$${product["price"]}"),
                        const SizedBox(height: 5),
                        Text("Category: ${product["category"]}",style: TextStyle(color: Colors.amber),),
                        const SizedBox(height: 5),
                        Text(" Description:\n${product["description"]}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                        const SizedBox(height: 5),
                        Row(
                          children: [

                            ...List.generate(5, (index) {
                              double rate = product["rating"]["rate"];
                              if (rate >= index + 1) {
                                return const Icon(Icons.star, color: Colors.amber, size: 20);
                              } else if (rate > index && rate < index + 1) {
                                return const Icon(Icons.star_half, color: Colors.amber, size: 20);
                              } else {
                                return const Icon(Icons.star_border, color: Colors.amber, size: 20);
                              }
                            }),
                            const SizedBox(width: 8),

                            Text(
                              "${product["rating"]["rate"]} (${product["rating"]["count"]} reviews)",
                              style: const TextStyle(color: Colors.black87, fontSize: 13),
                            ),
                          ],
                        ),



                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
