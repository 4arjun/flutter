import 'package:flutter/material.dart';
import 'package:lascade_demo_app/models/cart_item.dart';
import '../providers/cart_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Cart extends ConsumerStatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  ConsumerState<Cart> createState() => _CartState();
}

class _CartState extends ConsumerState<Cart> {
  // Sample cart data - you would typically get this from a provider or state management solution

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);

    final subtotal = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
    final deliveryFee = 4.99;
    final taxes = subtotal * 0.08;
    final total = subtotal + deliveryFee + taxes;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:
          cartItems.isEmpty
              ? _buildEmptyCart()
              : Column(
                children: [
                  Expanded(child: _buildCartItemsList()),
                  _buildOrderSummary(
                    subtotal: subtotal,
                    deliveryFee: deliveryFee,
                    taxes: taxes,
                    total: total,
                  ),
                ],
              ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart,
              size: 50,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: const Text(
              'Browse our Products and add some to your cart!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to recipes page
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF37A99B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              'Browse Products',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsList() {
    final cartItems = ref.watch(cartProvider);
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return _buildCartItem(item);
      },
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.network(item.product.image, fit: BoxFit.fill),
            ),
          ),
          const SizedBox(width: 16),
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${item.product.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        _buildQuantityButton(
                          icon: SvgPicture.asset(
                            'assets/images/minus.svg',
                            width: 24,
                            height: 24,
                          ),
                          onPressed:
                              () => ref
                                  .read(cartProvider.notifier)
                                  .decreaseNumber(item),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 12),
                        _buildQuantityButton(
                          icon: SvgPicture.asset(
                            'assets/images/plus.svg',
                            width: 24,
                            height: 24,
                          ),
                          onPressed:
                              () => ref
                                  .read(cartProvider.notifier)
                                  .increaseNumber(item),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(width: 28, height: 28, child: icon),
    );
  }

  Widget _buildOrderSummary({
    required double subtotal,
    required double deliveryFee,
    required double taxes,
    required double total,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', subtotal),
          const SizedBox(height: 12),
          _buildSummaryRow('Delivery fee', deliveryFee),
          const SizedBox(height: 12),
          _buildSummaryRow('Taxes', taxes),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF37A99B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to checkout page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF37A99B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ],
    );
  }
}
