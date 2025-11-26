
import 'package:flutter/cupertino.dart';

import '../Utils/Constant/ApiConfig/ApiEndPoints.dart';

class ImageUtility {
  static ImageProvider buildImageProvider(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else {
      return NetworkImage(ApiEndPoints.imagePath+""+ imageUrl);
    }
  }

  static ImageUrl(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return imageUrl;
    } else {
      return ApiEndPoints.imagePath+""+ imageUrl;
    }
  }
}
