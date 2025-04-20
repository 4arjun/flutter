import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:lascade_demo_app/models/product.dart";
import "package:lascade_demo_app/screens/cart.dart";
import "package:lascade_demo_app/widgets/feature_cards.dart";
import "package:lascade_demo_app/widgets/category_select.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/details_screen.dart';
import "package:lascade_demo_app/providers/product_providers.dart";
import "package:lascade_demo_app/widgets/popular_cards.dart";
import 'package:another_flushbar/flushbar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = "electronics";

  @override
  Widget build(BuildContext context) {
    bool errorShown = false;
    void showErrorFlushbar(BuildContext context, String message) {
      if (errorShown) return;

      errorShown = true;

      Flushbar(
        message: message,
        flushbarPosition: FlushbarPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(8),
        backgroundColor: Colors.red.shade400,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error_outline, color: Colors.white),
      ).show(context);
    }

    categorySelect((category) {
      setState(() {
        selectedCategory = category;
      });
    });
    final featuredProducts = ref.watch(featuredProductsProvider);
    final popularProducts = ref.watch(
      categoryProductProvider(selectedCategory),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 16.0, right: 16.0),
            child: appbar(context),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured section
            const Text(
              "Featured",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),

            _featuredSpace(
              context,
              featuredProducts,
              showErrorFlushbar,
              errorShown,
            ),

            const SizedBox(height: 40),

            // Category section
            categoryHeading(),
            const SizedBox(height: 10),

            categorySelect((category) {
              setState(() {
                selectedCategory = category;
              });
            }),

            const SizedBox(height: 30),
            _popularSpaceHeading(),

            // Popular Products section
            const SizedBox(height: 10),

            _popularSpace(
              context,
              popularProducts,
              showErrorFlushbar,
              errorShown,
            ),
          ],
        ),
      ),
    );
  }
}

Widget appbar(BuildContext context) {
  final int currentHour = DateTime.now().hour;

  String greeting;
  String iconAsset;

  if (currentHour < 12) {
    greeting = "Good Morning";
    iconAsset = 'assets/images/Sun.svg';
  } else if (currentHour < 17) {
    greeting = "Good Afternoon";
    iconAsset = 'assets/images/Sun.svg';
  } else {
    greeting = "Good Evening";
    iconAsset = 'assets/images/moon.svg';
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // First row: Greeting and cart icon on same level
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Greeting
          Row(
            children: [
              SvgPicture.asset(iconAsset, width: 18, height: 18),
              const SizedBox(width: 5),
              Text(
                greeting,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),

          // Cart Icon
          GestureDetector(
            onTap: () {
              // Your action here (e.g., navigate to cart screen)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Cart()),
              );
            },
            child: SvgPicture.asset(
              'assets/images/Buy.svg',
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),

      // Second row: User name
      const Text(
        "Alena Sabyan",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
      ),
    ],
  );
}

Widget _featuredSpace(
  BuildContext context,
  AsyncValue<List<Product>> featuredProducts,
  void Function(BuildContext, String) showErrorFlushbar,
  bool errorShown,
) {
  return SizedBox(
    height: 172,
    child: featuredProducts.when(
      data:
          (products) => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              // Extract the category from description (assuming format: "category: value;")
              String category = "other";
              if (products[index].description.contains("category:")) {
                final categoryMatch = RegExp(
                  r'category:\s*([^;]+)',
                ).firstMatch(products[index].description);
                if (categoryMatch != null) {
                  category = categoryMatch.group(1)?.trim() ?? "other";
                }
              } else {
                // Fallback: use a general category or extract from somewhere else
                category = "electronics";
              }

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: FeatureCards(
                  title: products[index].title,
                  image: products[index].image,
                  price: products[index].price,
                  category: category,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(product: products[index]),
                      ),
                    );
                  },
                ),
              );
            },
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showErrorFlushbar(context, "Check your network");
        });
        return const Center(child: Text("Something went wrong"));
      },
    ),
  );
}

Widget categoryHeading() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: const [
      Text(
        "Category",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
      Text(
        "See All",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Color(0xFF70B9BE),
        ),
      ),
    ],
  );
}

Widget categorySelect(void Function(String) onCategorySelected) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [CategorySelect(onCategorySelected: onCategorySelected)],
    ),
  );
}

Widget _popularSpaceHeading() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: const [
      Text(
        "Popular Products",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
      Text(
        "See All",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Color(0xFF70B9BE),
        ),
      ),
    ],
  );
}

Widget _popularSpace(
  BuildContext context,
  AsyncValue<List<Product>> popularProducts,
  void Function(BuildContext, String) showErrorFlushbar,
  bool errorShown,
) {
  return SizedBox(
    height: 290,
    child: popularProducts.when(
      data:
          (products) => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: PopularCards(
                  product: products[index],
                  showDetails: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(product: products[index]),
                      ),
                    );
                  },
                ),
              );
            },
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showErrorFlushbar(context, "Check your network");
        });

        return const Center(child: Text("Something went wrong"));
      },
    ),
  );
}
