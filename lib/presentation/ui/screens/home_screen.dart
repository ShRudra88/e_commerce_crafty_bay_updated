import 'package:e_commerce_crafty_bay_updated/presentation/ui/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../state_holders/auth_controller.dart';
import '../../state_holders/category_controller.dart';
import '../../state_holders/home_banner_controller.dart';
import '../../state_holders/main_bottom_nav_controller.dart';
import '../../state_holders/new_product_controller.dart';
import '../../state_holders/popular_product_controller.dart';
import '../../state_holders/special_product_controller.dart';
import '../helping_widgets/banner_carosel.dart';
import '../helping_widgets/center_circular_progress_indicator.dart';
import '../helping_widgets/circle_icon_button.dart';
import '../helping_widgets/product_card_item.dart';
import '../helping_widgets/section_title.dart';
import '../utility/assets_path.dart';
import 'auth/complete_profile_screen.dart';
import 'auth/verify_email_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              searchTextField,
              const SizedBox(height: 20),

              /// ------------------- BANNER ---------------------
              SizedBox(
                height: 240,
                child: GetBuilder<HomeBannerController>(
                  builder: (homeBannerController) {
                    return Visibility(
                      visible: !homeBannerController.inProgress,
                      replacement: const CenterCircularProgressIndicator(),
                      child: BannerCarousel(
                        bannerList: homeBannerController.bannerListModel.bannerList ?? [],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              SectionTitle(
                title: 'All Categories',
                onTapSeeAll: () {
                  Get.find<MainBottomNavController>().changeIndex(1);
                },
              ),
              categoryList,

              const SizedBox(height: 10),

              SectionTitle(
                title: 'Popular',
                onTapSeeAll: () => Get.to(() => const ProductListScreen()),
              ),
              GetBuilder<PopularProductController>(
                builder: (popularProductController) {
                  return Visibility(
                    visible: !popularProductController.inProgress,
                    replacement: const CenterCircularProgressIndicator(),
                    child: productList(popularProductController.productListModel.productList ?? []),
                  );
                },
              ),

              const SizedBox(height: 16),

              SectionTitle(title: 'Special', onTapSeeAll: () {
                Get.to(() => const ProductListScreen());
              }),
              GetBuilder<SpecialProductController>(
                builder: (specialProductController) {
                  return Visibility(
                    visible: !specialProductController.inProgress,
                    replacement: const CenterCircularProgressIndicator(),
                    child: productList(specialProductController.productListModel.productList ?? []),
                  );
                },
              ),

              const SizedBox(height: 16),

              SectionTitle(title: 'New', onTapSeeAll: () {
                Get.to(() => const ProductListScreen());
              }),
              GetBuilder<NewProductController>(
                builder: (newProductController) {
                  return Visibility(
                    visible: !newProductController.inProgress,
                    replacement: const CenterCircularProgressIndicator(),
                    child: productList(newProductController.productListModel.productList ?? []),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- CATEGORY LIST -----------------
  SizedBox get categoryList {
    return SizedBox(
      height: 190,
      child: GetBuilder<CategoryController>(
        builder: (categoryController) {
          return Visibility(
            visible: !categoryController.inProgress,
            replacement: const CenterCircularProgressIndicator(),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categoryController.categoryListModel.categoryListItem?.length ?? 0,
              itemBuilder: (context, index) {
                final item = categoryController.categoryListModel.categoryListItem![index];
                final imgUrl = item.categoryImg;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: (imgUrl == null || imgUrl.isEmpty)
                          ? _noImageFoundWidget()
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imgUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _noImageFoundWidget(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 120,
                      child: Text(
                        item.categoryName ?? "Unknown",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 14),
            ),
          );
        },
      ),
    );
  }

// ---------------- NO IMAGE ----------------
  Widget _noImageFoundWidget() {
    return Center(
      child: Text(
        "No Image",
        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
      ),
    );
  }

// ---------------- PRODUCT LIST ----------------
  SizedBox productList(List<ProductModel> productList) {
    return SizedBox(
      height: 215,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: productList.length,
        itemBuilder: (context, index) => ProductCardItem(product: productList[index]),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
      ),
    );
  }

// ---------------- SEARCH BAR ----------------
  TextFormField get searchTextField {
    return TextFormField(
      style: const TextStyle(fontSize: 17),
      decoration: InputDecoration(
        hintText: 'Search products',
        hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade200,
        prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 26),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  AppBar get appBar {
    return AppBar(
      title: Image.asset(AssetsPath.logoNav, height: 40),
      actions: [
        CircleIconButton(
          size: 45,
          iconSize: 24,
          onTap: () async {
            await AuthController.clearAuthData();
            Get.to(CompleteProfileScreen());
          },
          iconData: Icons.person,
        ),
        const SizedBox(width: 8),

        // ---------------- Call Button ----------------
        CircleIconButton(
          size: 45,
          iconSize: 22,
          onTap: () {
            Get.dialog(
              AlertDialog(
                title: const Text("Call Support"),
                content: const Text("Do you want to call our support number?"),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      Get.snackbar("Calling", "Calling support...");
                    },
                    child: const Text("Call"),
                  ),
                ],
              ),
            );
          },
          iconData: Icons.call,
        ),

        const SizedBox(width: 8),

        // ---------------- Notification Button ----------------
        CircleIconButton(
          size: 45,
          iconSize: 22,
          onTap: () {
            Get.dialog(
              AlertDialog(
                title: const Text("Notifications"),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("• New order update available."),
                    SizedBox(height: 6),
                    Text("• You received 3 new messages."),
                    SizedBox(height: 6),
                    Text("• Flash sale is starting soon!"),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Close"),
                  ),
                ],
              ),
            );
          },
          iconData: Icons.notifications_active_outlined,
        ),

        const SizedBox(width: 12),
      ],
    );
  }

}
