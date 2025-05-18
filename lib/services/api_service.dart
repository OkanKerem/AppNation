import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../models/breed.dart';

class ApiService {
  static const _base = 'https://dog.ceo/api';
  final _cacheManager = DefaultCacheManager();

  Future<List<Breed>> fetchAllBreeds() async {
    try {
      print('Fetching all breeds...');
      final resp = await http.get(Uri.parse('$_base/breeds/list/all'));
      print('Breeds response status: ${resp.statusCode}');
      print('Breeds response body: ${resp.body}');
      
      if (resp.statusCode != 200) {
        throw Exception('Failed to fetch breeds: ${resp.statusCode}');
      }
      
      final data = json.decode(resp.body)['message'] as Map<String, dynamic>;
      final list = <Breed>[];
      
      data.forEach((breed, subs) {
        final subBreedsList = (subs as List).cast<String>();
        list.add(Breed(
          name: breed,
          subBreeds: subBreedsList,
        ));
        
        if (subBreedsList.isNotEmpty) {
          for (var sub in subBreedsList) {
            list.add(Breed(
              name: '$breed-$sub',
              isSubBreed: true,
              subBreeds: const [],
            ));
          }
        }
      });
      
      print('Parsed breeds: ${list.map((b) => '${b.name} (${b.apiPath})').join(', ')}');
      return list;
    } catch (e) {
      print('Error fetching breeds: $e');
      throw Exception('Failed to fetch breeds: $e');
    }
  }

  Future<void> fetchRandomImage(Breed breed) async {
    try {
      final uri = Uri.parse('$_base/breed/${breed.apiPath}/images/random');
      print('Fetching random image for breed: ${breed.name} (${breed.apiPath})');
      print('Request URL: $uri');
      
      final resp = await http.get(uri);
      print('Random image response status: ${resp.statusCode}');
      print('Random image response body: ${resp.body}');
      
      if (resp.statusCode != 200) {
        throw Exception('Failed to fetch random image: ${resp.statusCode}');
      }
      
      final data = json.decode(resp.body);
      if (data['status'] != 'success') {
        throw Exception('API returned error: ${data['message']}');
      }
      
      final imageUrl = data['message'] as String;
      print('Got image URL: $imageUrl');
      
      breed.imageUrl = imageUrl;
    } catch (e) {
      print('Error fetching random image: $e');
      throw Exception('Failed to fetch random image: $e');
    }
  }

  Future<String> getRandomImage(String breedName) async {
    try {
      final breed = Breed(name: breedName);
      final apiPath = breed.apiPath;
      
      final uri = Uri.parse('$_base/breed/$apiPath/images/random');
      print('Fetching random image for breed: $breedName ($apiPath)');
      print('Request URL: $uri');
      
      final resp = await http.get(uri);
      print('Random image response status: ${resp.statusCode}');
      print('Random image response body: ${resp.body}');
      
      if (resp.statusCode != 200) {
        print('Failed to fetch random image: ${resp.statusCode}');
        return breed.defaultImageUrl;
      }
      
      final data = json.decode(resp.body);
      if (data['status'] != 'success') {
        print('API returned error: ${data['message']}');
        return breed.defaultImageUrl;
      }
      
      final imageUrl = data['message'] as String;
      print('Got image URL: $imageUrl');
      
      // Verify the image URL is accessible
      final imageResp = await http.head(Uri.parse(imageUrl));
      if (imageResp.statusCode != 200) {
        print('Image URL is not accessible: $imageUrl');
        return breed.defaultImageUrl;
      }
      
      await _cacheManager.getSingleFile(imageUrl);
      return imageUrl;
    } catch (e) {
      print('Error fetching random image: $e');
      return Breed(name: breedName).defaultImageUrl;
    }
  }

  Future<String> getRandomDogImage() async {
    try {
      final uri = Uri.parse('$_base/breeds/image/random');
      final resp = await http.get(uri);
      
      if (resp.statusCode != 200) {
        throw Exception('Failed to fetch random image: ${resp.statusCode}');
      }
      
      final data = json.decode(resp.body);
      if (data['status'] != 'success') {
        throw Exception('API returned error: ${data['message']}');
      }
      
      final imageUrl = data['message'] as String;
      final file = await _cacheManager.getSingleFile(imageUrl);
      return file.path;
    } catch (e) {
      throw Exception('Failed to fetch random image: $e');
    }
  }

  Future<List<String>> getAllBreedImages(String breedId) async {
    try {
      final uri = Uri.parse('$_base/breed/$breedId/images');
      print('Fetching all images for breed: $breedId');
      print('Request URL: $uri');
      
      final resp = await http.get(uri);
      print('All images response status: ${resp.statusCode}');
      
      if (resp.statusCode != 200) {
        throw Exception('Failed to fetch breed images: ${resp.statusCode}');
      }
      
      final data = json.decode(resp.body);
      if (data['status'] != 'success') {
        throw Exception('API returned error: ${data['message']}');
      }
      
      final urls = List<String>.from(data['message']);
      print('Got ${urls.length} images for breed $breedId');
      
      final files = await Future.wait(
        urls.map((url) => _cacheManager.getSingleFile(url))
      );
      return files.map((file) => file.path).toList();
    } catch (e) {
      print('Error fetching all images: $e');
      throw Exception('Failed to fetch breed images: $e');
    }
  }

  Future<List<String>> getSubBreeds(String breedId) async {
    try {
      final uri = Uri.parse('$_base/breed/$breedId/list');
      print('Fetching subbreeds for breed: $breedId');
      print('Request URL: $uri');
      
      final resp = await http.get(uri);
      print('Subbreeds response status: ${resp.statusCode}');
      print('Subbreeds response body: ${resp.body}');
      
      if (resp.statusCode != 200) {
        throw Exception('Failed to fetch subbreeds: ${resp.statusCode}');
      }
      
      final data = json.decode(resp.body);
      if (data['status'] != 'success') {
        throw Exception('API returned error: ${data['message']}');
      }
      
      final subbreeds = List<String>.from(data['message']);
      print('Got subbreeds: ${subbreeds.join(', ')}');
      return subbreeds;
    } catch (e) {
      print('Error fetching subbreeds: $e');
      throw Exception('Failed to fetch subbreeds: $e');
    }
  }

  Future<void> preloadAllBreedImages() async {
    try {
      print('Starting to preload all breed images...');
      final breeds = await fetchAllBreeds();
      print('Fetched ${breeds.length} breeds, starting to load images...');
      
      // Load one random image per breed in parallel, but handle errors individually
      final results = await Future.wait(
        breeds.map((breed) async {
          try {
            final imageUrl = await getRandomImage(breed.name);
            if (imageUrl != null) {
              breed.imageUrl = imageUrl;
              print('Successfully loaded image for ${breed.name}: $imageUrl');
            } else {
              print('Failed to load image for ${breed.name}, using default');
              breed.imageUrl = breed.defaultImageUrl;
            }
            return imageUrl;
          } catch (error) {
            print('Failed to load image for breed ${breed.name}: $error');
            breed.imageUrl = breed.defaultImageUrl;
            return null;
          }
        }),
        eagerError: false,
      );
      
      // Count successful loads
      final successfulLoads = results.where((result) => result != null).length;
      print('Successfully loaded $successfulLoads out of ${breeds.length} breed images');
      
    } catch (e) {
      print('Error in preloadAllBreedImages: $e');
    }
  }

  Future<void> clearCache() async {
    print('Clearing image cache...');
    await _cacheManager.emptyCache();
    print('Cache cleared');
  }
}
