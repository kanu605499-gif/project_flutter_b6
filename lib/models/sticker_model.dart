/// Sticker model for the Amomimus sticker stash system.
///
/// Firestore-ready with [fromMap] / [toMap] support.
class StickerModel {
  final String id;
  final String name;
  final String imageAsset;
  final String category;
  final String batchId; // Supports grouping stickers into batches
  final int price;
  final String? createdAt;

  StickerModel({
    required this.id,
    required this.name,
    required this.imageAsset,
    this.category = 'general',
    this.batchId = 'batch_1',
    this.price = 100,
    this.createdAt,
  });

  /// Firestore-ready: converts this [StickerModel] to a [Map].
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageAsset': imageAsset,
      'category': category,
      'batchId': batchId,
      'price': price,
      'createdAt': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  /// Firestore-ready: creates a [StickerModel] from a [Map].
  factory StickerModel.fromMap(Map<String, dynamic> map) {
    return StickerModel(
      id: map['id'],
      name: map['name'],
      imageAsset: map['imageAsset'],
      category: map['category'] ?? 'general',
      batchId: map['batchId'] ?? 'batch_1',
      price: map['price'] ?? 100,
      createdAt: map['createdAt'],
    );
  }
}
