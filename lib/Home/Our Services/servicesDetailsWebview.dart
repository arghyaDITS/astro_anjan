import 'package:astro_app/components/util.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ServiceDetailWeb extends StatefulWidget {
  final int? index;
  const ServiceDetailWeb({Key? key, required this.index}) : super(key: key);

  @override
  _ServiceDetailWebState createState() => _ServiceDetailWebState();
}

class _ServiceDetailWebState extends State<ServiceDetailWeb> {
  late final WebViewController _controller;
  String serviceUrl =
      'https://anjanshastri.com/best-astrologer-in-india-dr-anjan-shastri/';
        bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.index == 1) {
      serviceUrl =
          'https://anjanshastri.com/best-astrologer-in-india-dr-anjan-shastri/';
    }
    if(widget.index==2)
    {
     serviceUrl =
          'https://anjanshastri.com/best-palmist-in-india-dr-anjan-shastri/'; 
    }
    if(widget.index==3)
    {
     serviceUrl =
          'https://anjanshastri.com/best-numerologer-in-india-dr-anjan-shastri/'; 
    }
    if(widget.index==4)
    {
     serviceUrl =
          'https://anjanshastri.com/vastu-expert-for-home-dr-anjan-shastri/'; 
    }
    if(widget.index==5)
    {
     serviceUrl =
          'https://anjanshastri.com/kusti/'; 
    }
    else
    {
     serviceUrl =
          'https://anjanshastri.com/best-astrologer-in-india-dr-anjan-shastri/'; 
    }
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
      ..loadRequest(Uri.parse(serviceUrl));
    // Initialize the WebViewController here if necessary
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
         // title: Text('About Us'),
        ),
        body: Stack(
          children: [
            WebViewWidget(
              controller: _controller,
            ),
            if(isLoading)
            Center(child: LoadingIcon(),)
          ],
        )
        
        //WebView(
        //   initialUrl: 'https://your-webpage-url.com',
        //   javascriptMode: JavascriptMode.unrestricted,
        // ),
        );
  }
}
