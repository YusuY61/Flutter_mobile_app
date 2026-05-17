import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../services/products_data.dart';
import 'product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> tumUrunler = [];
  List<Product> gosterilenUrunler = [];

  @override
  void initState() {
    super.initState();
    urunleriYukle();
  }

  void urunleriYukle() {
    List<dynamic> jsonList = jsonDecode(productsJsonString);

    List<Product> liste = [];
    for (var i = 0; i < jsonList.length; i++) {
      liste.add(Product.fromJson(jsonList[i]));
    }

    setState(() {
      tumUrunler = liste;
      gosterilenUrunler = liste;
    });
  }

  void aramaYap(String metin) {
    List<Product> sonuc = [];
    if (metin.isEmpty) {
      sonuc = tumUrunler;
    } else {
      for (var i = 0; i < tumUrunler.length; i++) {
        if (tumUrunler[i]
            .name
            .toLowerCase()
            .contains(metin.toLowerCase())) {
          sonuc.add(tumUrunler[i]);
        }
      }
    }
    setState(() {
      gosterilenUrunler = sonuc;
    });
  }

  void sepetiAc() async {
    await Navigator.pushNamed(context, '/cart');
    setState(() {});
  }

  void detayiAc(Product urun) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: urun),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Katalog'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: sepetiAc,
              ),
              if (CartService.getCount() > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      CartService.getCount().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(15),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.local_offer, color: Colors.white, size: 36),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'GIFT STORE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Indirimli Urunler',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Urun ara...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: aramaYap,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: gosterilenUrunler.isEmpty
                ? const Center(child: Text('Urun bulunamadi'))
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: gosterilenUrunler.length,
                    itemBuilder: (context, index) {
                      Product urun = gosterilenUrunler[index];
                      return GestureDetector(
                        onTap: () {
                          detayiAc(urun);
                        },
                        child: Card(
                          elevation: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  color: Colors.grey.shade200,
                                  child: Image.network(
                                    urun.image,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image,
                                        size: 80,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      urun.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      urun.category,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${urun.price.toStringAsFixed(0)} TL',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
