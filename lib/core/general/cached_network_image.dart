import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({super.key, required this.image,  this.fit = BoxFit.cover,});
  final String image;
  final BoxFit? fit;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: fit,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: fit)),
      ),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.blue,
        highlightColor: Colors.grey,
        child: Container(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.image_not_supported_outlined,
        size: 25,
      ),
    );
  }
}
