import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meiyou/core/constants/assets.dart';

class ImageHolderMemory extends StatelessWidget {
  final double height;
  final double width;
  final Uint8List? bytes;
  final BoxFit? fit;

  const ImageHolderMemory({
    super.key,
    required this.height,
    required this.width,
    this.bytes,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (bytes == null || bytes!.isEmpty) return _fallbackAssetImage();
    return Image.memory(
      bytes!,
      height: height,
      width: width,
      fit: fit ?? BoxFit.fill,
      errorBuilder: (context, error, stackTrace) => _fallbackAssetImage(),
    );
  }

  Widget _fallbackAssetImage() {
    return Image.asset(
      defaultImage,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
    );
  }
}

class ImageHolder extends StatelessWidget {
  final double height;
  final double width;
  final String? imageUrl;
  final BoxFit? fit;

  const ImageHolder({
    super.key,
    required this.height,
    required this.width,
    this.imageUrl,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _fallbackAssetImage();
    }
    if (imageUrl!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.fill,
        errorWidget: (context, url, error) => _fallbackAssetImage(),
      );
    }
    return Image.file(File(imageUrl!),
        height: height,
        width: width,
        fit: fit ?? BoxFit.fill,
        errorBuilder: (context, error, stackTrace) => _fallbackAssetImage());
  }

  Widget _fallbackAssetImage() {
    return Image.asset(
      defaultImage,
      height: height,
      width: width,
      fit: fit ?? BoxFit.cover,
    );
  }
}
