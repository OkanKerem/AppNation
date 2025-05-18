class Breed {
  final String name;
  String? imageUrl;
  final bool isSubBreed;
  final List<String> subBreeds;

  Breed({
    required this.name, 
    this.isSubBreed = false, 
    this.imageUrl,
    this.subBreeds = const [],
  });
  
  /// transform "hound-afghan" → "hound/afghan"
  /// or "afghan hound" → "hound/afghan" for sub-breeds
  String get apiPath {
    if (!isSubBreed) {
      return name.replaceAll('-', '/');
    }
    // For sub-breeds, reverse the name parts and use hyphen
    final parts = name.split(' ');
    if (parts.length == 2) {
      return '${parts[1]}/${parts[0]}';
    }
    return name.replaceAll(' ', '/');
  }

  /// Get the default image URL for this breed
  String get defaultImageUrl {
    // Use a placeholder image that we know exists
    return "https://images.dog.ceo/breeds/retriever-golden/n02099601_1633.jpg";
  }
}
