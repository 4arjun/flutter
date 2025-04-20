import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import '../models/product.dart';
import "package:lascade_demo_app/models/cart_item.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorite_providers.dart';
import '../providers/cart_providers.dart';

class PopularCards extends ConsumerStatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final bool showDetails;
  const PopularCards({
    super.key,
    required this.product,
    required this.onTap,
    required this.showDetails,
  });
  ConsumerState<PopularCards> createState() => _PopularState();
}

class _PopularState extends ConsumerState<PopularCards> {
  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(favoriteProvider).contains(widget.product.id);
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 200,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, right: 5),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              widget.product.image,
                              width: 168,
                              height: 128,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 15,
                        right: 5,
                        child: GestureDetector(
                          onTap:
                              () => {
                                ref
                                    .read(favoriteProvider.notifier)
                                    .toggleFavorite(widget.product),
                              },
                          child: Container(
                            child:
                                isFav
                                    ? SvgPicture.asset(
                                      "assets/images/Active.svg",
                                      width: 60,
                                      height: 60,
                                    )
                                    : SvgPicture.asset(
                                      "assets/images/Love.svg",
                                      width: 60,
                                      height: 60,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 80,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          widget.product.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),
                  widget.showDetails
                      ? Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Price with dollar icon
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.attach_money,
                                        size: 16,
                                        color: Colors.black87,
                                      ),
                                      Text(
                                        widget.product.price.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Cart icon button
                                  InkWell(
                                    onTap: () {
                                      ref
                                          .read(cartProvider.notifier)
                                          .addToCart(
                                            CartItem(product: widget.product),
                                          );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF37A99B),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.shopping_cart,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      : SizedBox.shrink(),
                ],
              ),
            ),

            // Background image
          ],
        ),
      ),
    );
  }
}
