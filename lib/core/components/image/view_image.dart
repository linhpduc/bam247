
import 'package:flutter/material.dart';

import 'image_viewer.dart';

class ImageData {
  List<String> urls;
  int index;

  ImageData({this.urls = const [], this.index = 0});
}

class ViewImage extends StatelessWidget {

  final ImageData data;

  const ViewImage(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          _ImageGallery(data),
          const SafeArea(child: BackButton(color: Colors.white)),
        ],
      ),
    );
  }
}

class _ImageGallery extends StatefulWidget {
  final ImageData data;

  const _ImageGallery(this.data, {Key? key}) : super(key: key);

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.data.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemBuilder: (BuildContext context, int index) {
        return InteractiveViewer.builder(
          builder: (_, __) => ImageViewer(widget.data.urls[index]),
          minScale: 1,
          maxScale: 20,
        );
      },
      itemCount: widget.data.urls.length,
      controller: pageController,
      onPageChanged: _onPageChanged,
    );
  }

  void _onPageChanged(int index) {}

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
