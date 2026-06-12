import '../models/sticker_model.dart';

class StickersDB {
  static final List<StickerModel> allStickers = [
    StickerModel(
      id: 'stk_001',
      name: 'Happy Amo',
      imageAsset: 'assets/stickers/happy_amo.png',
      category: 'emotions',
      batchId: 'batch_1',
      price: 50,
    ),
    StickerModel(
      id: 'stk_002',
      name: 'Sad Amom',
      imageAsset: 'assets/stickers/sad_amom.png',
      category: 'emotions',
      batchId: 'batch_1',
      price: 50,
    ),
    StickerModel(
      id: 'stk_003',
      name: 'Angry Ami',
      imageAsset: 'assets/stickers/angry_ami.png',
      category: 'emotions',
      batchId: 'batch_1',
      price: 50,
    ),
    StickerModel(
      id: 'stk_004',
      name: 'Golden Diamond',
      imageAsset: 'assets/stickers/golden_diamond.png',
      category: 'premium',
      batchId: 'batch_2',
      price: 500,
    ),
    StickerModel(
      id: 'stk_005',
      name: 'Police Tape',
      imageAsset: 'assets/stickers/police_tape.png',
      category: 'premium',
      batchId: 'batch_2',
      price: 300,
    ),
  ];

  static StickerModel? getStickerById(String id) {
    try {
      return allStickers.firstWhere((sticker) => sticker.id == id);
    } catch (e) {
      return null;
    }
  }
}
