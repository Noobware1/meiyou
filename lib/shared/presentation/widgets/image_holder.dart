import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class _ImageHolderMemory extends ImageHolder {
  const _ImageHolderMemory({
    super.key,
    required super.height,
    required super.width,
    required super.image,
    super.fit,
  });

  @override
  Widget build(BuildContext context) {
    final bytes = _image as Uint8List?;
    if (bytes == null || bytes.isEmpty) return _fallbackAssetImage();
    return Image.memory(
      bytes,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _fallbackAssetImage(),
    );
  }
}

class _ImageHolderNetwork extends ImageHolder {
  const _ImageHolderNetwork({
    super.key,
    required super.height,
    required super.width,
    required super.image,
    super.fit,
  });

  @override
  Widget build(BuildContext context) {
    final url = _image as String?;
    if (url == null || url.isEmpty) return _fallbackAssetImage();
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      errorWidget: (context, url, error) => _fallbackAssetImage(),
    );
  }
}

class _ImageHolderFile extends ImageHolder {
  const _ImageHolderFile({
    super.key,
    required super.height,
    required super.width,
    required super.image,
    super.fit,
  });

  @override
  Widget build(BuildContext context) {
    final file = _image as File?;
    if (file == null) return _fallbackAssetImage();
    return Image.file(
      file,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _fallbackAssetImage(),
    );
  }
}

abstract class ImageHolder extends StatelessWidget {
  final double height;
  final double width;
  final Object? _image;
  final BoxFit fit;

  const ImageHolder({
    super.key,
    required this.height,
    required this.width,
    required Object? image,
    this.fit = BoxFit.fill,
  }) : _image = image;

  factory ImageHolder.memory({
    Key? key,
    required double height,
    required double width,
    required Uint8List? bytes,
    BoxFit fit = BoxFit.fill,
  }) =>
      _ImageHolderMemory(
        key: key,
        height: height,
        width: width,
        image: bytes,
        fit: fit,
      );

  factory ImageHolder.network({
    Key? key,
    required double height,
    required double width,
    required String? url,
    BoxFit fit = BoxFit.fill,
  }) =>
      _ImageHolderNetwork(
        key: key,
        height: height,
        width: width,
        image: url,
        fit: fit,
      );

  factory ImageHolder.file({
    Key? key,
    required double height,
    required double width,
    required File file,
    BoxFit fit = BoxFit.fill,
  }) =>
      _ImageHolderFile(
        key: key,
        height: height,
        width: width,
        image: file,
        fit: fit,
      );

  @override
  Widget build(BuildContext context);

  Widget _fallbackAssetImage() {
    return Image.asset(
      '',
      // defaultImage,
      height: height,
      width: width,
      fit: fit,
    );
  }
}
