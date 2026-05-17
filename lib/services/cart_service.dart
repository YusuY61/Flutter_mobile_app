import '../models/product.dart';

class CartService {
  static List<Product> items = [];

  static void add(Product product) {
    items.add(product);
  }

  static void remove(Product product) {
    items.remove(product);
  }

  static int getCount() {
    return items.length;
  }

  static double getTotal() {
    double toplam = 0;
    for (var i = 0; i < items.length; i++) {
      toplam = toplam + items[i].price;
    }
    return toplam;
  }

  static void clear() {
    items.clear();
  }
}
