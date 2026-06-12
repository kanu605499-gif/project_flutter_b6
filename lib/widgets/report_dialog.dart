import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../amomimusdark.dart';
import '../models/report_model.dart';
import '../services/account_manager.dart';

class ReportDialog extends StatefulWidget {
  final String targetId; // can be a messageId or userId
  final bool isUserReport; // true if reporting user profile, false if reporting message

  const ReportDialog({
    super.key,
    required this.targetId,
    this.isUserReport = false,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  ReportCategory _selectedCategory = ReportCategory.spamHarassment;
  final TextEditingController _commentController = TextEditingController();
  bool _banUser = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReport() {
    final comment = _commentController.text.trim();
    if (_banUser && comment.isEmpty) {
      // Should not happen as checkbox is disabled if comment is empty
      return;
    }
    
    final accountManager = context.read<AccountManager>();
    
    // Process the report to update points and indicators
    accountManager.submitReport(
      widget.targetId,
      _selectedCategory,
      isChatBubbleReport: !widget.isUserReport,
    );
    
    if (_banUser) {
      // Block the user locally. We assume targetId for isUserReport is the realAuthorId/userId.
      accountManager.blockUser(widget.targetId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted and user blocked.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully.')),
      );
    }

    Navigator.pop(context, true); // true = success
  }

  @override
  Widget build(BuildContext context) {
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final isDark = amomimusTheme.isDarkMode;

    final bgColor = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final textSecondaryColor = isDark ? Colors.white70 : Colors.black54;
    final accentColor = isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple;
    final borderColor = isDark ? Colors.white24 : Colors.black12;

    return Dialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                const SizedBox(width: 8),
                Text(
                  widget.isUserReport ? "Report User" : "Report Message",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "Select a category:",
              style: TextStyle(color: textSecondaryColor, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: ReportCategory.values.map((category) {
                  return RadioListTile<ReportCategory>(
                    title: Text(
                      ReportCategoryHelper.getLabel(category),
                      style: TextStyle(color: textColor, fontSize: 15),
                    ),
                    value: category,
                    groupValue: _selectedCategory,
                    activeColor: accentColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Detailed comment (required for ban):",
              style: TextStyle(color: textSecondaryColor, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 3,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: "Please provide details...",
                hintStyle: TextStyle(color: textSecondaryColor.withOpacity(0.5)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: accentColor),
                ),
              ),
              onChanged: (val) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Theme(
              data: ThemeData(
                unselectedWidgetColor: textSecondaryColor,
              ),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: accentColor,
                title: Text(
                  "Block / Ban User",
                  style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  "You must provide a comment to enable this.",
                  style: TextStyle(color: textSecondaryColor, fontSize: 12),
                ),
                value: _banUser,
                onChanged: _commentController.text.trim().isEmpty
                    ? null
                    : (val) {
                        setState(() => _banUser = val ?? false);
                      },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: textSecondaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Submit Report"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
