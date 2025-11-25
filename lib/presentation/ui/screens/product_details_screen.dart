import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:item_count_number_button/item_count_number_button.dart';
import '../../../data/models/product_details_data.dart';
import '../../state_holders/add_to_controller.dart';
import '../../state_holders/auth_controller.dart';
import '../../state_holders/product_details_controller.dart';
import '../helping_widgets/center_circular_progress_indicator.dart';
import '../helping_widgets/color_selector.dart';
import '../helping_widgets/product_image_carosol.dart';
import '../helping_widgets/size_selector.dart';
import '../utility/app_colors.dart';
import 'auth/verify_email_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final int productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ValueNotifier<int> noOfItems = ValueNotifier(1);

  Color? _selectedColor;
  String? _selectedSize;

  @override
  void initState() {
    super.initState();
    Get.find<ProductDetailsController>().getProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: GetBuilder<ProductDetailsController>(
        builder: (controller) {
          if (controller.inProgress || controller.productDetails == null) {
            return const CenterCircularProgressIndicator();
          }

          final productDetails = controller.productDetails!;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ProductImageCarousel(
                        urls: [
                          productDetails.img1 ?? '',
                          productDetails.img2 ?? '',
                          productDetails.img3 ?? '',
                          productDetails.img4 ?? '',
                        ].where((e) => e.isNotEmpty).toList(),
                      ),
                      productDetailsBody(productDetails),
                    ],
                  ),
                ),
              ),
              priceAndAddToCartSection(productDetails)
            ],
          );
        },
      ),
    );
  }

  // ================== PRODUCT BODY ===================

  Padding productDetailsBody(ProductDetailsData productDetails) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  productDetails.product?.title ?? '',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: noOfItems,
                builder: (context, value, _) {
                  return ItemCount(
                    initialValue: value,
                    minValue: 1,
                    maxValue: 20,
                    decimalPlaces: 0,
                    color: AppColors.primaryColor,
                    onChanged: (v) => noOfItems.value = v.toInt(),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 10),
          reviewAndRatingRow(productDetails.product?.star ?? 0),

          const SizedBox(height: 16),
          const Text('Color', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          ColorSelector(
            colors: productDetails.color
                ?.split(',')
                .map((e) => getColorFromString(e))
                .toList() ??
                [],
            onChange: (color) => _selectedColor = color,
          ),

          const SizedBox(height: 16),
          const Text('Size', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          SizeSelector(
            sizes: productDetails.size?.split(',') ?? [],
            onChange: (s) => _selectedSize = s,
          ),

          const SizedBox(height: 16),
          const Text('Description', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          Text(productDetails.des ?? '', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // ================== RATING ===================

  Row reviewAndRatingRow(int rating) {
    return Row(
      children: [
        const Icon(Icons.star, size: 18, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsPrecision(2),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black45),
        ),
        const SizedBox(width: 8),
        const Text(
          'Reviews',
          style: TextStyle(fontSize: 16, color: AppColors.primaryColor, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Card(
          color: AppColors.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(Icons.favorite_outline_rounded, size: 18, color: Colors.white),
          ),
        )
      ],
    );
  }

  // ================== BOTTOM PRICE BAR ===================

  Widget priceAndAddToCartSection(ProductDetailsData productDetails) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.15),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '\$${productDetails.product?.price ?? 0}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
          ),

          SizedBox(
            width: 100,
            child: GetBuilder<AddToCartController>(
              builder: (addToCartController) {
                if (addToCartController.inProgress) {
                  return const CenterCircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () async {
                    if (_selectedColor == null || _selectedSize == null) {
                      Get.showSnackbar(const GetSnackBar(
                        title: 'Failed',
                        message: 'Select color and size',
                        duration: Duration(seconds: 2),
                      ));
                      return;
                    }

                    if (!Get.find<AuthController>().isTokenNotNull) {
                      Get.to(() => const VerifyEmailScreen());
                      return;
                    }

                    final colorString = colorToString(_selectedColor!);

                    final success = await addToCartController.addToCart(
                      widget.productId,
                      colorString,
                      _selectedSize!,
                      noOfItems.value,
                    );

                    if (success) {
                      Get.showSnackbar(const GetSnackBar(
                        title: 'Added',
                        message: 'Product added to cart',
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      Get.showSnackbar(GetSnackBar(
                        title: 'Failed',
                        message: addToCartController.errorMessage,
                        duration: const Duration(seconds: 2),
                      ));
                    }
                  },
                  child: const Text('Add to Cart'),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // ================== COLOR UTILS ===================

  Color getColorFromString(String color) {
    switch (color.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'white':
        return Colors.white;
      case 'green':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String colorToString(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.white) return 'White';
    if (color == Colors.green) return 'Green';
    return 'Grey';
  }
}
