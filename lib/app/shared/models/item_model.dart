class ItemModel {
  final int id;
  final String title;
  final String imageUrl;

  ItemModel({this.id, this.title, this.imageUrl});

  factory ItemModel.fromMap(Map json) => ItemModel(
      id: json["id"], title: json["title"], imageUrl: json["image_url"]);
}
