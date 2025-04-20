import 'package:flutter/material.dart';

class FeatureCards extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;
  final double price;
  final String category;

  const FeatureCards({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
    required this.price,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    // You can change this width to make the card smaller/larger
    double cardWidth = 260;
    double aspectRatio = 1;
    double cardHeight = cardWidth / aspectRatio;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Stack(
          children: [
            // Background image
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  image,
                  width: 200,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ),
            ),

            // Semi-transparent overlay
            Container(
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(150, 0, 0, 0), // ~47% opacity black
              ),
            ),

            // Product info container at the bottom
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product title
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 160,
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Category and Price in the same row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Category on the left
                        Flexible(
                          child: Row(
                            children: [
                              Icon(
                                Icons.category,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  category.capitalize(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Price on the right
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 14,
                              color: Colors.white,
                            ),
                            Text(
                              price.toStringAsFixed(2),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
