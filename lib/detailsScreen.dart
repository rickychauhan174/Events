import 'package:flutter/material.dart';

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
        title: Text('Event Detail'),
        actions: [
          IconButton(onPressed: (){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Event added to Google Calendar'),
            ));
          }, icon: Icon(Icons.add))
        ],
      ),
      body: Center(
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
    );
  }
}
