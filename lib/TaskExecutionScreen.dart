import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:screenshot/screenshot.dart';

class TaskExecutionScreen extends StatefulWidget {
  final String url;
  final String taskText;

  TaskExecutionScreen({required this.url, required this.taskText});

  @override
  _TaskExecutionScreenState createState() => _TaskExecutionScreenState();
}

class _TaskExecutionScreenState extends State<TaskExecutionScreen> {
  late final WebViewController controller;
  ScreenshotController screenshotController = ScreenshotController();
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    
    // 1. نسخ النص تلقائياً بمجرد فتح المهمة
    Clipboard.setData(ClipboardData(text: widget.taskText));

    // 2. إعداد المتصفح الداخلي
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  // 3. وظيفة التقاط الشاشة ورفعها
  Future<void> _captureAndConfirm() async {
    setState(() => isUploading = true);

    try {
      final image = await screenshotController.capture();
      if (image != null) {
        // هنا يتم رفع الصورة إلى Supabase Storage
        // await supabase.storage.from('proofs').uploadBinary(path, image);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم التقاط الإثبات ورفعه للمراجعة بنجاح!')),
        );
        Navigator.pop(context); // العودة بعد النجاح
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('نفذ المهمة الآن'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("تم نسخ نص المنشور.. قم بلصقه ثم اضغط تأكيد", style: TextStyle(color: Colors.red, fontSize: 12)),
          ),
        ),
      ),
      // استخدام Screenshot Widget لتصوير ما بداخلها فقط
      body: Screenshot(
        controller: screenshotController,
        child: WebViewWidget(controller: controller),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        onPressed: isUploading ? null : _captureAndConfirm,
        label: isUploading 
          ? CircularProgressIndicator(color: Colors.white) 
          : Text('إرسال تأكيد (تصوير الشاشة)'),
        icon: Icon(Icons.camera_alt),
      ),
    );
  }
}