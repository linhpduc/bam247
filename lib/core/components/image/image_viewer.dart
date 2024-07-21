import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:batt247/core/components/image/svg_comp.dart';
import 'package:batt247/core/extensions/string.dart';
import 'view_image.dart';

enum TypeImageViewer { none, assets, storage, network, web, svg }

class ImageViewer extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final BoxFit fit;
  final Color? color;
  final bool hasViewImage;
  final Widget? defaultImg;
  final Color? backgroundColor;
  final double? borderWidth;
  final Color? borderColor;
  final Uint8List? bytes;
  final TypeImageViewer? imageType;

  const ImageViewer(
    this.url, {
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
    this.bytes,
    this.defaultImg,
    this.padding,
    this.fit = BoxFit.contain,
    this.color,
    this.hasViewImage = false,
    this.backgroundColor,
    this.borderWidth,
    this.borderColor,
    this.imageType,
  }) : super(key: key);

  TypeImageViewer? get type {
    if (imageType != null) return imageType;
    if (url.isWebPicker()) {
      return TypeImageViewer.web;
    } else if (url.isStorage()) {
      return TypeImageViewer.storage;
    } else if (url.isValidUrl) {
      return TypeImageViewer.network;
    } else if (url.isAssetsPng()) {
      return TypeImageViewer.assets;
    } else if (url.isAssetsSvg()) {
      return TypeImageViewer.svg;
    }
    return TypeImageViewer.none;
  }

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty || type == TypeImageViewer.none) {
      return defaultImg ?? const SizedBox.shrink();
    }
    return InkWell(
      onTap: hasViewImage ? _onTap(context) : null,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(0),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(color: backgroundColor),
          child: _imageWidget(),
        ),
      ),
    );
  }

  Widget _imageWidget() {
    switch (type) {
      case TypeImageViewer.network:
        return Container();
      case TypeImageViewer.storage:
        return Image.file(File(url), fit: fit);
      case TypeImageViewer.svg:
        return SvgComp(
            url: url,
            width: width,
            height: height,
            borderRadius: borderRadius,
            color: color);
      case TypeImageViewer.web:
        if (bytes == null) {
          return Image.memory(base64Decode(url), fit: fit);
        } else {
          return Image.memory(bytes!, fit: fit);
        }
      default:
        return Image.asset(
          url,
          fit: fit,
          color: color,
        );
    }
  }

  _onTap(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ViewImage(ImageData(urls: [url]))));
  }
}
