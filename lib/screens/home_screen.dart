import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _products = [];
  bool _isLoading = true;
  String _selectedCategory = "electronics";

  final List<String> categories = [
    "electronics",
    "jewelery",
    "men's clothing",
    "women's clothing",
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final products = await ProductService.fetchProducts();
      // Shuffle the products to get different order each time
      products.shuffle();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error appropriately
      debugPrint('Error fetching products: $e');
    }
  }

  List<Product> get filteredProducts {
    return _products
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  List<Product> get featuredProducts {
    // Get random products from all categories for featured section
    if (_products.isEmpty) return [];
    final shuffled = List<Product>.from(_products)..shuffle();
    return shuffled.take(10).toList();
  }

  double wp(BuildContext context, double width) =>
      MediaQuery.of(context).size.width * (width / 430);
  double hp(BuildContext context, double height) =>
      MediaQuery.of(context).size.height * (height / 932);
  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "🌤 Good Morning";
    } else if (hour >= 12 && hour < 18) {
      return "☀️ Good Afternoon";
    } else if (hour >= 18 && hour < 22) {
      return "🌇 Good Evening";
    } else {
      return "🌙 Good Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF1B3834),
        child: const Icon(Icons.restaurant_menu, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomNavBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: wp(context, 20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(context),
                SizedBox(height: hp(context, 24)),
                buildFeaturedSection(context),
                SizedBox(height: hp(context, 24)),
                buildCategorySection(context),
                SizedBox(height: hp(context, 24)),
                buildPopularSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------
  // Header
  Widget buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getGreeting(),
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            Text(
              "Alena Sabyan",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: wp(context, 24),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(
            Icons.shopping_cart_outlined,
            size: wp(context, 24),
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // ----------------------------
  Widget buildFeaturedSection(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final featuredProducts = this.featuredProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Featured",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: hp(context, 16)),
        SizedBox(
          height: hp(context, 180),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: featuredProducts.length,
            separatorBuilder: (_, __) => SizedBox(width: wp(context, 16)),
            itemBuilder: (context, index) {
              final product = featuredProducts[index];
              return Container(
                width: wp(context, 280),
                decoration: BoxDecoration(
                  color: const Color(0xFFA0DAD4),
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(product.image),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                      Colors.black54,
                      BlendMode.darken,
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: wp(context, 200), // Limiting text width
                      child: Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: wp(context, 16),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ----------------------------
  Widget buildCategorySection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Category",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            TextButton(
              onPressed: _fetchProducts, // Refresh products on tap
              child: const Text(
                "Refresh",
                style: TextStyle(
                  color: Color(0xFFA0DAD4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: hp(context, 12)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                categories.map((category) {
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: EdgeInsets.only(right: wp(context, 12)),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFFA0DAD4)
                                  : Colors.grey[100],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          category.split("'")[0].toUpperCase(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  // ----------------------------
  Widget buildPopularSection(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final products = filteredProducts;

    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                "No products found in this category",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _fetchProducts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA0DAD4),
                ),
                child: const Text("Refresh Products"),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${_selectedCategory.split("'")[0].toUpperCase()} Products",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            TextButton(
              onPressed: _fetchProducts,
              child: const Text(
                "Refresh",
                style: TextStyle(
                  color: Color(0xFFA0DAD4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: hp(context, 16)),
        SizedBox(
          height: hp(context, 280),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, __) => SizedBox(width: wp(context, 16)),
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                width: wp(context, 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Image.network(
                            product.image,
                            height: hp(context, 180),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(Icons.favorite_border, size: 20),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.price.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.category,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    product.category,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
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
            },
          ),
        ),
      ],
    );
  }

  // ----------------------------
  Widget buildBottomNavBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      elevation: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: const Color(0xFFA0DAD4),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search),
              color: Colors.grey,
              onPressed: () {},
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.notifications_none),
              color: Colors.grey,
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              color: Colors.grey,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
