import 'package:flutter_test/flutter_test.dart';

Map<String, int> calculateStock(List purchases, List sales) {
  final Map<String, int> stock = {};

  for (final item in purchases) {
    final name = item["category"] as String;
    final qty = item["quantity"] as int;
    stock[name] = (stock[name] ?? 0) + qty;
  }

  for (final item in sales) {
    final name = item["itemName"] as String;
    final qty = item["quantity"] as int;
    stock[name] = (stock[name] ?? 0) - qty;
  }

  return stock;
}

void main() {

  test("stock calculation basic case", () {
    final stock = calculateStock(
      [{"category": "Coke", "quantity": 10}],
      [{"itemName": "Coke", "quantity": 3}],
    );

    expect(stock["Coke"], 7);
  });

  test("multiple purchases accumulate", () {
    final stock = calculateStock(
      [
        {"category": "Coke", "quantity": 10},
        {"category": "Coke", "quantity": 5}
      ],
      [],
    );

    expect(stock["Coke"], 15);
  });

  test("sales reduce stock", () {
    final stock = calculateStock(
      [{"category": "Pepsi", "quantity": 20}],
      [{"itemName": "Pepsi", "quantity": 5}],
    );

    expect(stock["Pepsi"], 15);
  });

  test("sales greater than purchases creates negative stock", () {
    final stock = calculateStock(
      [{"category": "Fanta", "quantity": 5}],
      [{"itemName": "Fanta", "quantity": 10}],
    );

    expect(stock["Fanta"], -5);
  });

  test("empty purchases returns negative sales", () {
    final stock = calculateStock(
      [],
      [{"itemName": "Sprite", "quantity": 4}],
    );

    expect(stock["Sprite"], -4);
  });

  test("empty lists return empty stock", () {
    final stock = calculateStock([], []);
    expect(stock.isEmpty, true);
  });

}