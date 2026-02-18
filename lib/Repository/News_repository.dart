import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/Model/Categories_News_Model.dart';
import 'package:news_app/Model/News_Channel_Headline_Model.dart';

class NewRepository {


  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(
    String source,
  ) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=$source&apiKey=d30294580089486ca810a904ba29738a';

    final response = await http.get(Uri.parse(url));

    if (kDebugMode) {
      print("API URL: $url");
      print(response.body);
    }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
    } else {
      throw Exception("Error fetching news: ${response.statusCode}");
    }
  }

  Future<CategoriesNewsModel> fetchCategeriesApi(
      String category,
      ) async {
    String url =
        'https://newsapi.org/v2/everything?q=${category}&apiKey=d30294580089486ca810a904ba29738a';

    final response = await http.get(Uri.parse(url));

    if (kDebugMode) {
      print("API URL: $url");
      print(response.body);
    }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    } else {
      throw Exception("Error fetching news: ${response.statusCode}");
    }
  }

}
