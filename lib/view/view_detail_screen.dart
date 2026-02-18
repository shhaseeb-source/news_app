import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewDetailScreen extends StatefulWidget {
  final String newImage,
      newTitle,
      newDate,
      author,
      description,
      content,
      source;

  const NewDetailScreen({
    super.key,
    required this.newImage,
    required this.newTitle,
    required this.newDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source,
  });

  @override
  State<NewDetailScreen> createState() => _NewDetailScreenState();
}

class _NewDetailScreenState extends State<NewDetailScreen> {
  final format = DateFormat('MMMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    DateTime dateTime=DateTime.parse(widget.newDate);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
          SizedBox(
            height: height * .45,

            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.newImage,
                fit: BoxFit.cover,
                placeholder: (context, ulr) =>
                    Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          Container(
            height: height*.6,
            margin: EdgeInsets.only(top: height*.4,),
            padding: EdgeInsets.only(top: 20,right: 20,left: 20),
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40),
              ),

            ),
            child: ListView(
              children: [
                Text(widget.newTitle,style: GoogleFonts.poppins(fontSize: 20,color: Colors.black87,fontWeight: FontWeight.w700),),
                SizedBox(height: height*0.02,),
                Row(
                  children: [
                    Expanded(child: Text(widget.source,style: GoogleFonts.poppins(fontSize: 13,color: Colors.black87,fontWeight: FontWeight.w600))),
                    Text(format.format(dateTime),style: GoogleFonts.poppins(fontSize: 12,color: Colors.black87,fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: height*0.02,),
                Text(widget.description,style: GoogleFonts.poppins(fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
