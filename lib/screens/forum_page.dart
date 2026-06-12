import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../amomimusdark.dart';
import '../language/language_manager.dart';
import '../services/feed_manager.dart';
import '../services/account_manager.dart';
import '../models/comment_model.dart';
import '../services/notification_manager.dart';
import '../models/notification_model.dart';
import '../data/anonymous_names.dart';
import '../models/post_model.dart';
import 'tugas9ui.dart'; // To reuse FeedCard
import 'profile_screen.dart';

class ForumPage extends StatefulWidget {
  final String feedId;

  const ForumPage({super.key, required this.feedId});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final TextEditingController _commentController = TextEditingController();
  CommentModel? _replyTarget;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final isDark = amomimusTheme.isDarkMode;
    
    final currentScaffoldBg =
        isDark ? AmomimusDarkTheme.backgroundDark : Colors.white;
    final currentTextPrimary =
        isDark ? AmomimusDarkTheme.textPrimary : Colors.black;

    return Scaffold(
      backgroundColor: currentScaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: currentScaffoldBg,
        elevation: 0,
        titleSpacing: 16,
        title: Text(
          context.watch<LanguageManager>().getString('post_detail'),
          style: TextStyle(
            color: isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Consumer<FeedManager>(
        builder: (context, feedManager, child) {
          FeedModel? feedModel;
          try {
            feedModel = feedManager.feeds.firstWhere((f) => f.id == widget.feedId);
          } catch (e) {
            feedModel = null;
          }

          if (feedModel == null) {
            return Center(
              child: Text(
                context.watch<LanguageManager>().getString('no_feeds'),
                style: TextStyle(color: currentTextPrimary),
              ),
            );
          }

          final currentFeed = feedModel;
          final feedIndex = feedManager.feeds.indexOf(currentFeed);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FeedCard(
                        model: currentFeed,
                        feedIndex: feedIndex,
                      ),
                      const Divider(),
                      if (currentFeed.comments.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            context.watch<LanguageManager>().getString('no_comments'),
                            style: TextStyle(color: currentTextPrimary),
                          ),
                        )
                      else
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: currentFeed.comments.length,
                          itemBuilder: (context, index) {
                            final comment = currentFeed.comments[index];
                            
                            // Deterministic Avatar Generation
                            final iconData = AnonymousNames.getConsistentIconForPost(comment.authorId, widget.feedId);
                            final iconColorValue = AnonymousNames.getConsistentColorForPost(comment.authorId, widget.feedId);
                            final iconColor = Color(iconColorValue);
                            
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: iconColor.withValues(alpha: 0.2),
                                child: Icon(
                                  iconData,
                                  color: iconColor,
                                ),
                              ),
                              title: Text(
                                "${comment.authorName} (${comment.authorId})", 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  color: isDark ? Colors.white70 : Colors.black87, 
                                  fontSize: 12,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (comment.replyToName != null && comment.replyToText != null)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4, bottom: 4),
                                      padding: const EdgeInsets.only(left: 8),
                                      decoration: const BoxDecoration(
                                        border: Border(left: BorderSide(color: Colors.grey, width: 2)),
                                      ),
                                      child: Text(
                                        "${context.watch<LanguageManager>().getString('replying_to')} ${comment.replyToName}:\n${comment.replyToText}",
                                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  Text(
                                    comment.text, 
                                    style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileScreen(targetUserId: comment.authorId),
                                  ),
                                );
                              },
                              onLongPress: () {
                                setState(() {
                                  _replyTarget = comment;
                                });
                                _focusNode.requestFocus();
                              },
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // Inline comment input
              Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_replyTarget != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${context.watch<LanguageManager>().getString('replying_to')} ${_replyTarget!.authorName}",
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black87,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: () {
                                setState(() {
                                  _replyTarget = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            focusNode: _focusNode,
                            controller: _commentController,
                            style: TextStyle(color: isDark ? Colors.white : Colors.black),
                            decoration: InputDecoration(
                              hintText: context.watch<LanguageManager>().getString('write_message'),
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send, color: AmomimusDarkTheme.primaryPurple),
                          onPressed: () {
                            final currentUser = Provider.of<AccountManager>(context, listen: false).currentUser;
                            if (_commentController.text.trim().isNotEmpty && currentUser != null) {
                              final generatedName = AnonymousNames.getConsistentNameForPost(currentUser.amomimusId, currentFeed.id);
                              final newComment = CommentModel(
                                authorId: currentUser.amomimusId,
                                authorName: generatedName,
                                text: _commentController.text,
                                timeStamp: "Just now",
                                replyToName: _replyTarget?.authorName,
                                replyToText: _replyTarget?.text,
                              );
                              
                              Provider.of<FeedManager>(context, listen: false).addComment(currentFeed.id, newComment);
                              
                              final notifManager = Provider.of<NotificationManager>(context, listen: false);
                              if (_replyTarget != null && _replyTarget?.authorId != currentUser.amomimusId) {
                                notifManager.addNotification(NotificationModel(
                                  targetUserId: _replyTarget!.authorId,
                                  actorName: generatedName,
                                  type: NotificationType.reply,
                                  feedId: currentFeed.id,
                                  message: "replied to your comment",
                                ));
                              } else if (currentFeed.realAuthorId != null && currentFeed.realAuthorId != currentUser.amomimusId) {
                                notifManager.addNotification(NotificationModel(
                                  targetUserId: currentFeed.realAuthorId!,
                                  actorName: generatedName,
                                  type: NotificationType.comment,
                                  feedId: currentFeed.id,
                                  message: "commented on your post",
                                ));
                              }
                              
                              _commentController.clear();
                              setState(() {
                                _replyTarget = null;
                              });
                              _focusNode.unfocus();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
