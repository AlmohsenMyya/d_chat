class CloudinaryHelper {
  static String getOptimizedUrl(String? url, {int? width, int? height}) {
    if (url == null || !url.contains('cloudinary.com')) return url ?? '';
    
    // Cloudinary URLs look like: https://res.cloudinary.com/demo/image/upload/sample.jpg
    // We want to insert transformation between 'upload/' and the rest.
    final parts = url.split('/upload/');
    if (parts.length != 2) return url;

    String transform = 'q_auto,f_auto';
    if (width != null && height != null) {
      transform += ',w_$width,h_$height,c_fill';
    } else if (width != null) {
      transform += ',w_$width,c_scale';
    }

    return '${parts[0]}/upload/$transform/${parts[1]}';
  }
}
