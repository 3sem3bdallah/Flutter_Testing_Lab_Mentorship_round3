import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/helper/cart_manager.dart';

void main() {
  group('CartManager Tests', () {
    late CartManager cart;

    setUp(() {
      cart = CartManager();
    });

    test('Add item increases subtotal', () {
      cart.addItem('1', 'Item A', 100);
      expect(cart.subtotal, 100);
    });

    test('Adding same item increases quantity not duplicates', () {
      cart.addItem('1', 'Item A', 50);
      cart.addItem('1', 'Item A', 50);
      expect(cart.items.length, 1);
      expect(cart.subtotal, 100);
    });

    test('Remove item empties the cart', () {
      cart.addItem('1', 'Item A', 100);
      cart.removeItem('1');
      expect(cart.subtotal, 0);
    });

    test('100% discount makes total = 0', () {
      cart.addItem('1', 'Item A', 100, discount: 1.0);
      expect(cart.totalAmount, 0);
    });

    test('Empty cart totals = 0', () {
      expect(cart.subtotal, 0);
      expect(cart.totalAmount, 0);
    });
  });
}