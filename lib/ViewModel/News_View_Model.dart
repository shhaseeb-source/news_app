

import 'package:news_app/Model/Categories_News_Model.dart';
import 'package:news_app/Model/News_Channel_Headline_Model.dart';

import '../Repository/News_repository.dart';

class NewsViewModel {
  final _rep = NewRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String name) async {
    return await _rep.fetchNewsChannelsHeadlinesApi(name);
  }

  Future<CategoriesNewsModel> fetchCategeriesApi(String name) async {
    return await _rep.fetchCategeriesApi(name);
  }
}
