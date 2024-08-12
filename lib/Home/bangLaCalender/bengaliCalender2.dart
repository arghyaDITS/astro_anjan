import 'package:astro_app/components/util.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BengaliCalendarScreen extends StatefulWidget {
  @override
  _BengaliCalendarScreenState createState() => _BengaliCalendarScreenState();
}

class _BengaliCalendarScreenState extends State<BengaliCalendarScreen> {
  late WebViewController _controller;
          bool isLoading = true;

  String aboutUsUrl = 'https://bengalicalendar.com/embed/index.php/';
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading=true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading=false;
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(aboutUsUrl));
    // Initialize the WebViewController here if necessary
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Bengali Calendar'),
        
        ),
        body: Stack(
          children: [
            WebViewWidget(
              controller: _controller,
            ),
            if(isLoading)
            Center(child: LoadingIcon(),)
          ],
        ));
  }
}
