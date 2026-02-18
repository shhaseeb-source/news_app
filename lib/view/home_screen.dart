import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Model/News_Channel_Headline_Model.dart';
import 'package:news_app/view/Category_Screen.dart';
import 'package:news_app/view/view_detail_screen.dart';
import '../Model/Categories_News_Model.dart';
import '../ViewModel/News_View_Model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, axios, espn, bloomberg, cnn, aljazeera }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;

  final format = DateFormat('MMMM dd, yyyy');
  String name = 'bbc-news'; // default channel

  String CatrgoryName = 'Entertaiment';

  late Future<NewsChannelsHeadlinesModel> headlinesFuture;
  late Future<CategoriesNewsModel> categoryFuture;

  @override
  void initState() {
    super.initState();
    headlinesFuture = newsViewModel.fetchNewsChannelsHeadlinesApi(name);
    categoryFuture = newsViewModel.fetchCategeriesApi(CatrgoryName);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .sizeOf(context)
        .height * 1;
    final width = MediaQuery
        .sizeOf(context)
        .width * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoryScreen()));
          },
          icon: Image.asset("images/category_icon.png", height: 30, width: 30),
        ),
        title: Text(
          "News",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            onSelected: (FilterList item) {
              if (item == FilterList.bbcNews) {
                name = "bbc-news";
              } else if (item == FilterList.cnn) {
                name = "cnn";
              } else if (item == FilterList.axios) {
                name = "axios";
              } else if (item == FilterList.bloomberg) {
                name = "bloomberg";
              } else if (item == FilterList.aljazeera) {
                name = "al-jazeera-english";
              } else if (item == FilterList.espn) {
                name = "espn";
              }

              setState(() {
                selectedMenu = item;
              });
            },
            icon: Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<FilterList>>[
              const PopupMenuItem<FilterList>(
                  value: FilterList.bbcNews, child: Text('BBC News')),
              const PopupMenuItem<FilterList>(
                  value: FilterList.cnn, child: Text('CNN News')),
              const PopupMenuItem<FilterList>(
                  value: FilterList.axios, child: Text('Axios')),
              const PopupMenuItem<FilterList>(
                  value: FilterList.bloomberg, child: Text('Bloomberg')),
              const PopupMenuItem<FilterList>(
                  value: FilterList.espn, child: Text('Espn')),
              const PopupMenuItem<FilterList>(
                  value: FilterList.aljazeera, child: Text('Al Jazeera')),
            ],
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelsHeadlinesApi(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(size: 50, color: Colors.blue),
                  );
                } else
                if (!snapshot.hasData || snapshot.data!.articles == null) {
                  return Center(
                    child: Text("No news found."),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime datetime = DateTime.parse(
                          snapshot.data!.articles![index].publishedAt
                              .toString());
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  NewDetailScreen(
                                  newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                  newTitle: snapshot.data!.articles![index].title.toString(),
                                  newDate: snapshot.data!.articles![index].publishedAt.toString(),
                                  author: snapshot.data!.articles![index].author.toString(),
                                  description: snapshot.data!.articles![index].description.toString(),
                                  content: snapshot.data!.articles![index].content.toString(),
                                  source: snapshot.data!.articles![index].source!.name.toString(),
                                  )));
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: height * 0.6,
                                width: width * 0.9,
                                padding: EdgeInsets.symmetric(
                                  horizontal: height * 0.02,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Container(child: spinkit2),
                                    errorWidget: (context, url, error) =>
                                        Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 25,
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    alignment: Alignment.bottomCenter,
                                    padding: EdgeInsets.all(12),
                                    height: height * 0.22,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        Container(
                                          width: width * 0.7,
                                          child: Text(
                                            snapshot.data!.articles![index]
                                                .title
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: width * 0.7,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                format.format(datetime),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategeriesApi(CatrgoryName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(size: 50, color: Colors.blue),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles == null) {
                  return Center(child: Text("No news found."));
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime datetime = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt
                            .toString(),
                      );
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  NewDetailScreen(
                                    newImage: snapshot.data!.articles![index].urlToImage.toString(),
                                    newTitle: snapshot.data!.articles![index].title.toString(),
                                    newDate: snapshot.data!.articles![index].publishedAt.toString(),
                                    author: snapshot.data!.articles![index].author.toString(),
                                    description: snapshot.data!.articles![index].description.toString(),
                                    content: snapshot.data!.articles![index].content.toString(),
                                    source: snapshot.data!.articles![index].source!.name.toString(),
                                  )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot
                                      .data!
                                      .articles![index]
                                      .urlToImage
                                      .toString(),
                                  fit: BoxFit.cover,
                                  height: height * 0.18,
                                  width: width * .3,
                                  placeholder: (context, url) =>
                                      Container(
                                        child: Center(
                                          child: SpinKitCircle(
                                            size: 50,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: height * .18,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black54,
                                        ),
                                        maxLines: 3,

                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index]
                                                .source!
                                                .name
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54,
                                            ),
                                            maxLines: 3,

                                          ),
                                          Text(
                                            format.format(datetime),
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,

                                            ),
                                            maxLines: 3,

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
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(color: Colors.amber, size: 50);
