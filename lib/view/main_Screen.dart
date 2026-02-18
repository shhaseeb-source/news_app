import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Model/News_Channel_Headline_Model.dart';
import '../ViewModel/News_View_Model.dart';
import 'Category_Screen.dart';
import 'view_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme(ThemeMode mode) {
    setState(() {
      themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "News",
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 1,
        ),
      ),
      themeMode: themeMode,
      home: MainScreen(
        onThemeChange: toggleTheme,
        themeMode: themeMode,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final void Function(ThemeMode) onThemeChange;
  final ThemeMode themeMode;

  const MainScreen({
    super.key,
    required this.onThemeChange,
    required this.themeMode,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  final List<Map<String, String>> newsChannels = [
    {"name": "bbc-news", "title": "BBC News", "logo": "images/bbc.png"},
    {"name": "cnn", "title": "CNN News", "logo": "images/cnn.png"},
    {"name": "bloomberg", "title": "Bloomberg", "logo": "images/bloomberg.png"},
    {"name": "espn", "title": "ESPN", "logo": "images/espn.png"},
    {
      "name": "al-jazeera-english",
      "title": "Al Jazeera",
      "logo": "images/aljazeera.png"
    },
    {"name": "the-verge", "title": "The Verge", "logo": "images/verge.png"},
    {
      "name": "techcrunch",
      "title": "TechCrunch",
      "logo": "images/techcrunch.png"
    },
    {"name": "fox-news", "title": "Fox News", "logo": "images/fox.png"},
  ];

  final NewsViewModel newsViewModel = NewsViewModel();
  final DateFormat format = DateFormat('MMM dd, yyyy');
  final spinkit2 = const SpinKitCircle(size: 30, color: Colors.blue);

  final ScrollController _scrollController = ScrollController();

  final Map<String, Future<NewsChannelsHeadlinesModel>> _newsFutureCache = {};

  Future<NewsChannelsHeadlinesModel> _getNews(String channelName) {
    if (!_newsFutureCache.containsKey(channelName)) {
      _newsFutureCache[channelName] =
          newsViewModel.fetchNewsChannelsHeadlinesApi(channelName);
    }
    return _newsFutureCache[channelName]!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoryScreen()));
          },
          icon: Image.asset("images/category_icon.png", height: 30, width: 30),
        ),
        title: Center(
          child: Text(
            "News",
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (value) {
              if (value == "light") {
                widget.onThemeChange(ThemeMode.light);
              } else if (value == "dark") {
                widget.onThemeChange(ThemeMode.dark);
              }
            },
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: "light",
                checked: widget.themeMode == ThemeMode.light,
                child: const Text("Light Theme"),
              ),
              CheckedPopupMenuItem(
                value: "dark",
                checked: widget.themeMode == ThemeMode.dark,
                child: const Text("Dark Theme"),
              ),
            ],
          )
        ],
      ),

      body: ListView.builder(
        key: const PageStorageKey("mainList"),
        controller: _scrollController,
        itemCount: newsChannels.length,
        itemBuilder: (context, index) {
          final channel = newsChannels[index];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Channel Title
              ListTile(
                leading: Image.asset(
                  channel["logo"]!,
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
                ),
                title: Text(
                  channel["title"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              ),

              // News Grid
              FutureBuilder<NewsChannelsHeadlinesModel>(
                future: _getNews(channel["name"]!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 200,
                      child: Center(child: spinkit2),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Error loading news: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.articles == null ||
                      snapshot.data!.articles!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text("No news available."),
                    );
                  } else {
                    return SizedBox(
                      height: 250,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, newsIndex) {
                          final article = snapshot.data!.articles![newsIndex];

                          DateTime datetime = DateTime.tryParse(
                              article.publishedAt.toString()) ??
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
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).cardColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: article.urlToImage ?? "",
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Center(child: spinkit2),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                            height: 120,
                                            width: double.infinity,
                                            color: Colors.grey.shade300,
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              size: 40,
                                              color: Colors.grey,
                                            ),
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      article.title ?? "No Title",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            article.source?.name ?? "",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                fontSize: 10),
                                          ),
                                        ),
                                        Text(
                                          format.format(datetime),
                                          style: GoogleFonts.poppins(
                                              fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
