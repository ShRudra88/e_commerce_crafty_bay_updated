// import 'category_list_item_model.dart';
//
// class CategoryListModel {
//   String? msg;
//   List<CategoryListItem>? categoryListItem;
//
//   CategoryListModel({this.msg, this.categoryListItem});
//
//   CategoryListModel.fromJson(Map<String, dynamic> json) {
//     msg = json['msg'];
//     if (json['data'] != null) {
//       categoryListItem = <CategoryListItem>[];
//       json['data'].forEach((v) {
//         categoryListItem!.add(new CategoryListItem.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['msg'] = this.msg;
//     if (this.categoryListItem != null) {
//       data['data'] = this.categoryListItem!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//


import 'category_list_item_model.dart';

class CategoryListModel {
  String? msg;
  List<CategoryListItem>? categoryListItem;
  int? total;
  int? next;
  int? lastPage;

  CategoryListModel({
    this.msg,
    this.categoryListItem,
    this.total,
    this.next,
    this.lastPage,
  });

  CategoryListModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];

    if (json["data"] != null) {
      total = json["data"]["total"];
      next = json["data"]["next"];
      lastPage = json["data"]["last_page"];

      if (json["data"]["results"] != null) {
        categoryListItem = <CategoryListItem>[];
        json["data"]["results"].forEach((v) {
          categoryListItem!.add(CategoryListItem.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['msg'] = msg;

    data["total"] = total;
    data["next"] = next;
    data["last_page"] = lastPage;

    if (categoryListItem != null) {
      data['results'] = categoryListItem!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
