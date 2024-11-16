import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerPlaceholder(
    {double width = double.infinity, double height = 20.0}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: width,
      height: height,
      color: Colors.white,
    ),
  );
}
