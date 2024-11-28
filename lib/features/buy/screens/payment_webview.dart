import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../core/constants/image_asset_constants.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String redirectUrl;

  const PaymentWebViewScreen({super.key, required this.redirectUrl});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late InAppWebViewController _controller;
  late InAppWebView _webView;

  @override
  void initState() {
    super.initState();
    _webView = InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(widget.redirectUrl))),
      onLoadStop: (controller, url) {
        // You can add logic here to detect successful payment based on URL or other indicators
        if (url.toString().contains("payment_success")) {
          // Handle payment success, navigate to the success screen
          Navigator.pushReplacementNamed(context, '/payment-success');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Payment',
      //     style: TextStyle(
      //         color: Colors.white,
      //         fontWeight: FontWeight.bold
      //     ),
      //   ),
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //       image: DecorationImage(
      //         opacity: 0.5,
      //         image: AssetImage(
      //             LocalImageConstants.bg2
      //         ),
      //         fit: BoxFit.cover,
      //       ),
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: _webView,
      ),
    );
  }
}
