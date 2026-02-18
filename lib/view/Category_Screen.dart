import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Model/Categories_News_Model.dart';
import 'package:news_app/view/view_detail_screen.dart';
import '../ViewModel/News_View_Model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin {
  final NewsViewModel newsViewModel = NewsViewModel();

  final format = DateFormat('MMMM dd, yyyy');
  String CatrgoryName = 'general';

  final List<String> CategoryList = [
    'general',
    'entertainment',
    'health',
    'sports',
    'business',
    'technology',
  ];

  final ScrollController _scrollController = ScrollController();


  Future<CategoriesNewsModel>? _categoryFuture;

  @override
  void initState() {
    super.initState();
    _categoryFuture = newsViewModel.fetchCategeriesApi(CatrgoryName);
  }

  void _changeCategory(String category) {
    setState(() {
      CatrgoryName = category;
      _categoryFuture = newsViewModel.fetchCategeriesApi(CatrgoryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Categories",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: CategoryList.length,
                itemBuilder: (context, index) {
                  final category = CategoryList[index];

                  return InkWell(
                    onTap: () {
                      _changeCategory(category);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: CatrgoryName == category
                              ? Colors.blue
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(
                            child: Text(
                              category.toUpperCase(),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: _categoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(size: 50, color: Colors.blue),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: GoogleFonts.poppins(color: Colors.red),
                      ),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.articles == null ||
                      snapshot.data!.articles!.isEmpty) {
                    return Center(
                      child: Text(
                        "No news found.",
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    key: const PageStorageKey("categoryList"),
                    controller: _scrollController,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      final article = snapshot.data!.articles![index];

                      DateTime datetime =
                          DateTime.tryParse(article.publishedAt.toString()) ??
                              DateTime.now();

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewDetailScreen(
                                newImage: article.urlToImage.toString(),
                                newTitle: article.title.toString(),
                                newDate: article.publishedAt.toString(),
                                author: article.author.toString(),
                                description: article.description.toString(),
                                content: article.content.toString(),
                                source: article.source!.name.toString(),
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: article.urlToImage ?? "",
                                  fit: BoxFit.cover,
                                  height: height * 0.18,
                                  width: width * 0.3,

                                  // ✅ Loading
                                  placeholder: (context, url) => Container(
                                    height: height * 0.18,
                                    width: width * 0.3,
                                    alignment: Alignment.center,
                                    child: const SpinKitCircle(
                                      size: 30,
                                      color: Colors.blue,
                                    ),
                                  ),

                                  // ✅ Fix decode issue (fallback image)
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        height: height * 0.18,
                                        width: width * 0.3,
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 35,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),

                              Expanded(
                                child: Container(
                                  height: height * 0.18,
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title ?? "No Title",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              article.source?.name ?? "",
                                              style: GoogleFonts.poppins(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black54,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            format.format(datetime),
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
