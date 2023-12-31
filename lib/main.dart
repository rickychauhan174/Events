import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:http/http.dart' as http;

import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:tiktoklikescroller/tiktoklikescroller.dart';
import 'package:untitled/detailsScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

import 'package:url_launcher/url_launcher_string.dart';

import 'SignInScreen.dart';


void main() async {
  firebaseInit();
  // setUrlStrategy(PathUrlStrategy());
  await Future.delayed(Duration(seconds: 1));
  // Check if the user is already authenticated
  User? user = FirebaseAuth.instance.currentUser;
  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final User? user;
  MyApp({required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aventi',
      debugShowCheckedModeBanner: false,
      // home: EventsPage(),
      home: user == null ? SignInScreen() : EventsPage(),
    );
  }
}

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<dynamic> ?events = [];
  int _currentPage = 0;


  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  void fetchEvents() async {
    //concert, sports, arts, music
    var baseUrl = "https://app.ticketmaster.com/discovery/v2/events.json?size=25&apikey=A70K1slSFWNOV3izO6m551q4RrLNQdIj&countryCode=CA";
    var ticketMasterConcertUrl = Uri.parse("$baseUrl&source=ticketmaster&classificationName=concert");
    var ticketMasterSportsUrl = Uri.parse("$baseUrl&source=ticketmaster&classificationName=sports");
    var ticketMasterArtsUrl = Uri.parse("$baseUrl&source=ticketmaster&classificationName=arts");
    var ticketMasterMusicUrl = Uri.parse("$baseUrl&source=ticketmaster&classificationName=music");

    var universeUrl = Uri.parse("$baseUrl&source=universe");

    //TM Concert
    final tmConcertResponse = await http.get(ticketMasterConcertUrl);
    if (tmConcertResponse.statusCode == 200) {
      final eventsJson = jsonDecode(tmConcertResponse.body)['_embedded']['events'];
      var list = eventsJson.map((eventJson) => Event.fromJson(eventJson)).toList();
      events?.addAll(list);
    }

    //TM Sports
    final tmSportsResponse = await http.get(ticketMasterSportsUrl);
    if (tmSportsResponse.statusCode == 200) {
      final eventsJson = jsonDecode(tmSportsResponse.body)['_embedded']['events'];
      var list = eventsJson.map((eventJson) => Event.fromJson(eventJson)).toList();
      events?.addAll(list);
    }

    //TM Arts
    final tmArtsResponse = await http.get(ticketMasterArtsUrl);
    if (tmArtsResponse.statusCode == 200) {
      final eventsJson = jsonDecode(tmArtsResponse.body)['_embedded']['events'];
      var list = eventsJson.map((eventJson) => Event.fromJson(eventJson)).toList();
      events?.addAll(list);
    }

    //TM Music
    final tmMusicResponse = await http.get(ticketMasterMusicUrl);
    if (tmMusicResponse.statusCode == 200) {
      final eventsJson = jsonDecode(tmMusicResponse.body)['_embedded']['events'];
      var list = eventsJson.map((eventJson) => Event.fromJson(eventJson)).toList();
      events?.addAll(list);
    }

    //Universe Concerts
   /* final uniResponse = await http.get(universeUrl);
    if (uniResponse.statusCode == 200) {
      final eventsJson = jsonDecode(uniResponse.body)['_embedded']['events'];
      var list = eventsJson.map((eventJson) => Event.fromJson(eventJson)).toList();
      events?.addAll(list);
    }*/

    setState(() {
      // events = eventsJson.map((eventJson) => Event.fromJson(eventJson)).toList();
      var prevList = events;
      prevList?.sort((a, b) {
        int aDate = DateTime.parse(a.date ?? '').microsecondsSinceEpoch;
        int bDate = DateTime.parse(b.date ?? '').microsecondsSinceEpoch;
        return aDate.compareTo(bDate);
      });
      // newList?.sort((a,b)=> b["date"].compareTo(a["date"]));
      events = prevList;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Under development'),
            ));
          }, icon: Icon(Icons.account_circle)),

          IconButton(onPressed: (){
            _signOut();
          }, icon: Icon(Icons.logout))
        ],
      ),
      body:
      TikTokStyleFullPageScroller(
        contentSize: events?.length??0,
        swipePositionThreshold: 0.2,
        // ^ the fraction of the screen needed to scroll
        swipeVelocityThreshold: 2000,
        // ^ the velocity threshold for smaller scrolls
        animationDuration: const Duration(milliseconds: 200),
        // ^ registering our own function to listen to page changes
        builder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailsScreen(event:events?[index] ,)))
              },
              child: EventCard(event: events?[index]));
        },
      )
      /*PageView(
        scrollDirection: Axis.vertical,
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: events.map((event) {
          return EventCard(event: event);
        }).toList(),
      ),*/
    );
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    // Redirect to the sign-in screen or any other screen as needed
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
  }
}

class Event {
  final String? name;
  final String? imageUrl;
  final String? type;
  final String? date;
  final String? info;
  final String? calDate;
  final String? url;

  Event({
    this.name,
    this.imageUrl,
    this.type,
    this.date,
    this.info,
    this.calDate,
    this.url,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'],
      info: json['info'],
      imageUrl: json['images'][4]['url'],
      type: json['type'],
      url: json['url'],
      date: json['dates']['start']['localDate'],
      calDate: json['dates']['start']['dateTime'],
    );
  }
}

class EventCard extends StatefulWidget {
  final Event? event;

  EventCard({this.event});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final _calendarApiScopes = [calendar.CalendarApi.calendarScope];
  final _credentialsJson =  '''
{"web":{"client_id":"276934932611-bh8a0dgr39n6b89q1sj8dpvbhsqmktf2.apps.googleusercontent.com",
"project_id":"sample-events","auth_uri":"https://accounts.google.com/o/oauth2/auth",
"token_uri":"https://oauth2.googleapis.com/token","auth_provider_x509_cert_url":"https://www.googleapis.com/oauth2/v1/certs",
"client_secret":"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"}}
''';
  late calendar.CalendarApi _calendarApi;

  @override
  void initState() {
    super.initState();
    // _initCalendarApi();
  }
  //
  // void _initCalendarApi() async {
  //   final credentials = auth.ServiceAccountCredentials.fromJson(_credentialsJson);
  //   final client = await auth.clientViaServiceAccount(credentials, _calendarApiScopes);//clientViaServiceAccount
  //   final calendarApi = calendar.CalendarApi(client);
  //   setState(() {
  //     _calendarApi = calendarApi;
  //   });
  // }



  Future<void> _addToGoogleCalendar() async {
    final event = calendar.Event()
      ..summary = widget.event?.name
      ..description = widget.event?.info
      ..start = calendar.EventDateTime(dateTime: DateTime.parse(widget.event?.date ?? ""))
      ..end = calendar.EventDateTime(dateTime: DateTime.parse(widget.event?.date ?? ""),); // Adjust the end time as needed

    try {
      //  await _calendarApi.events.insert(event, 'primary');
      await insertEvent(event);

    } catch (e) {
      print('Error adding event to Google Calendar: $e');
    }

  }
  insertEvent(event){
    try {
      clientViaUserConsent(ClientId("276934932611-bh8a0dgr39n6b89q1sj8dpvbhsqmktf2.apps.googleusercontent.com","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", ), _calendarApiScopes, prompt).then((AuthClient client){
        var calendar = CalendarApi(client);
        String calendarId = "primary";
        calendar.events.insert(event,calendarId).then((value) {
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Event added to Google Calendar'),
            ));
            log('Event added in google calendar');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Unable to add event in google calendar'),
            ));
            log("Unable to add event in google calendar");
          }
        });
      });
    } catch (e) {
      log('Error creating event $e');
    }
  }

  void prompt(String url) async {

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Image.network(
            widget.event?.imageUrl ?? "",
            width: 400,
            height: 600,
              fit: BoxFit.fitHeight
          ),
          Positioned(
            bottom: 10.0,
            left: 10.0,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.event?.name ?? "", style:
                  const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xffFFFFFF),
                    shadows: [
                      Shadow(
                        color: Color(0xff000000),
                        offset: Offset(2.0, 2.0),
                        blurRadius: 2.0,
                      ),
                    ],
                  ),),
                  Text(widget.event?.date ?? "",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Color(0xffFFFFFF),
                      shadows: [
                        Shadow(
                          color: Color(0xff000000),
                          offset: Offset(2.0, 2.0),
                          blurRadius: 2.0,
                        ),
                      ],
                    ),),
                ],
              ),
            ),
          ),
          Positioned(
            right: 10,
              bottom: 50,
              child: Column(
            children: [
              IconButton(onPressed: (){}, icon: Icon(Icons.favorite),color: Color(0xffffffff),),
             SizedBox(height: 10,),
              IconButton(onPressed: (){}, icon: Icon(Icons.comment),color: Color(0xffffffff)),
              SizedBox(height: 10,),
              IconButton(onPressed: (){}, icon: Icon(Icons.share),color: Color(0xffffffff)),
            ],
          ))
        ]
      ),
    );
  }
}


firebaseInit () async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBc7W6CqVfbp_Jhrl8zlbtbyWExTtDzsHQ',
          appId: '1:371323016199:web:0d51fc52403bbaddc886a2',
          messagingSenderId: '371323016199',
          projectId: 'sample-event-cfd8c',
          storageBucket: 'sample-event-cfd8c.appspot.com'));
}