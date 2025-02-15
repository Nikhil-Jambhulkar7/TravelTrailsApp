import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Widget to show cached image
Widget loadImage(String imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: (context, url) => const CircularProgressIndicator(),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}
