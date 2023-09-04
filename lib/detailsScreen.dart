import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'main.dart';

class DetailsScreen extends StatefulWidget {
 final Event?event;
   DetailsScreen({Key? key, this.event}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          backgroundColor: Color(0xff80cbc4),
          centerTitle: false,
          title: Text("AVENTI",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xff000000),
              shadows: [
                Shadow(
                  color: Color(0xffffffff),
                  offset: Offset(3.0, 3.0),
                  blurRadius: 3.0,
                ),
              ],
            ),),
        actions: [
          IconButton(onPressed: (){
            addEvent(widget.event?.name.toString() as String, widget.event?.info.toString() as String, widget.event?.calDate.toString() as String, "Canada");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Event added to Google Calendar'),
            ));
          }, icon: Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.event?.imageUrl??"")
                    )
                  ),
                ),
                SizedBox(height: 10,),
                Text("Name : ${widget.event?.name.toString()}",style: TextStyle(fontSize: 14),),
                SizedBox(height: 10,),
                Text("date : ${widget.event?.date.toString()}"),
                SizedBox(height: 10,),
                Text("info : ${widget.event?.info.toString()}"),
                SizedBox(height: 10,),
                Text("type : ${widget.event?.type.toString()}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addEvent(String title, String info, String date, String location) async {
    String url = "https://calendar.google.com/calendar/render?action=TEMPLATE&dates="
        + date + "/" + date
        + "&details="
        + info
        + "&location="
        + location
        + "&text="
         + title;
    await launchUrlString(url);
    await launchUrlString(url);
  }
}
