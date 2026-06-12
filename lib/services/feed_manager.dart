import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class FeedManager extends ChangeNotifier {
  List<FeedModel> _feeds = [];
  bool _isLoading = true;

  List<FeedModel> get feeds => _feeds;
  bool get isLoading => _isLoading;

  static const String _feedsKey = 'amomimus_app_feeds';

  Future<void> loadFeeds() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_feedsKey);

    if (data == null || data.isEmpty) {
      // Seed dummy data on first load
      _feeds = FeedModel.generateDummyData();
      await _saveFeeds();
    } else {
      try {
        final List<dynamic> decoded = jsonDecode(data);
        _feeds = decoded.map((json) => FeedModel.fromJson(json)).toList();
      } catch (e) {
        print('Error decoding feeds: $e');
        _feeds = FeedModel.generateDummyData();
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveFeeds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_feedsKey, jsonEncode(_feeds.map((e) => e.toJson()).toList()));
  }

  Future<void> addPost(FeedModel post) async {
    _feeds.insert(0, post); // Add to the top
    notifyListeners();
    await _saveFeeds();
  }

  Future<void> toggleResonate(String feedId, String userId) async {
    final index = _feeds.indexWhere((f) => f.id == feedId);
    if (index != -1) {
      final feed = _feeds[index];
      if (feed.resonatedBy.contains(userId)) {
        feed.resonatedBy.remove(userId);
      } else {
        feed.resonatedBy.add(userId);
      }
      notifyListeners();
      await _saveFeeds();
    }
  }

  Future<void> addComment(String feedId, CommentModel comment) async {
    final index = _feeds.indexWhere((f) => f.id == feedId);
    if (index != -1) {
      _feeds[index].comments.add(comment);
      notifyListeners();
      await _saveFeeds();
    }
  }

  Future<void> deletePost(int index) async {
    if (index >= 0 && index < _feeds.length) {
      _feeds.removeAt(index);
      notifyListeners();
      await _saveFeeds();
    }
  }

  Future<void> deletePostById(String feedId) async {
    final index = _feeds.indexWhere((f) => f.id == feedId);
    if (index != -1) {
      _feeds.removeAt(index);
      notifyListeners();
      await _saveFeeds();
    }
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_feedsKey);
    _feeds.clear();
    notifyListeners();
  }
}
