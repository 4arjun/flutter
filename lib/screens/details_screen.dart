import 'package:flutter/material.dart';
import 'package:lascade_demo_app/models/cart_item.dart';
import 'package:lascade_demo_app/models/product.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lascade_demo_app/widgets/button.dart';
import 'package:lascade_demo_app/widgets/buynow.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;
  const DetailsScreen({super.key, required this.product});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  double imageHeightFactor = 1.0;
  int quantity = 1;
  bool _isExpanded = false;

  double? imageHeight; // dynamic height based on original dimensions
  final double targetWidth = 300.0;

  @override
  void initState() {
    super.initState();
    _getImageDimensions();
  }

  void _getImageDimensions() {
    final Image image = Image.network(widget.product.image);

    image.image
        .resolve(ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            final double originalWidth = info.image.width.toDouble();
            final double originalHeight = info.image.height.toDouble();

            final double calculatedHeight =
                originalHeight * (targetWidth / originalWidth);

            setState(() {
              imageHeight = calculatedHeight;
            });

           
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 35),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Image that shrinks
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    height:
                        (imageHeight != null)
                            ? imageHeight! * imageHeightFactor
                            : 300, // temporary fixed height
                    width: double.infinity,
                    child:
                        (imageHeight != null)
                            ? Image.network(
                              widget.product.image,
                              fit: BoxFit.contain,
                              width: targetWidth,
                            )
                            : Center(child: CircularProgressIndicator()),
                  ),
                ),
                // Draggable Scrollable Sheet
                NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    setState(() {
                      double shrink = 1.0 - ((notification.extent - 0.5) * 1.5);
                      imageHeightFactor = shrink.clamp(0.7, 1.0);
                    });
                    return true;
                  },
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.7,
                    minChildSize: 0.6,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      final descriptionItems =
                          widget.product.description
                              .split(';')
                              .where((item) => item.trim().isNotEmpty)
                              .toList();

                      final displayedItems =
                          _isExpanded
                              ? descriptionItems
                              : descriptionItems.take(3).toList();

                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 10),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: ListView(
                            controller: scrollController,
                            children: [
                              Center(
                                child: Container(
                                  width: 40,
                                  height: 5,
                                  margin: EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(minHeight: 50),
                                child: IntrinsicHeight(
                                  child: Text(
                                    widget.product.title,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...displayedItems.map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "• ",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Expanded(
                                            child: Text(
                                              item.trim(),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (descriptionItems.length > 3)
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isExpanded = !_isExpanded;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Text(
                                          _isExpanded
                                              ? 'Show less'
                                              : 'Read more...',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "cost: \$ ${widget.product.price}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (quantity > 1) quantity--;
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/minus.svg',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                        ),
                                        child: Text(
                                          '$quantity',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            quantity++;
                                          });
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/plus.svg',
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Buynow(),
                                  Button(
                                    item: CartItem(
                                      product: widget.product,
                                      quantity: quantity,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
