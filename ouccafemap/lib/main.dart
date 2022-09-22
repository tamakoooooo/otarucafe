
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Set<Marker> _createMarker(){
    Set<Marker> markers = {};
    for(int i = 0 ; i < Data.info.length ; i++){
      markers.add(
        Marker(
          markerId: MarkerId(Data.info[i][0] as String),
          position: Data.info[i][2] as LatLng,
          onTap: (){
            showDialog(context: context, builder: ((context) {
              return AlertDialog(
                content: Container(
                  child: Column(
                    children: [
                     Text(Data.info[i][0] as String),
                     Row(
                      children: [
                        ElevatedButton(onPressed: (() async{
                          final url = Uri.parse("https://twitter.com/search?q="+(Data.info[i][3] as String));
                          await launchUrl(url);
                       
                        }), child: Text("Twitter")),

                         ElevatedButton(onPressed: (() async{
                          final url = Uri.parse("https://www.instagram.com/explore/tags/"+(Data.info[i][4] as String));
                          await launchUrl(url);
                          

                        }), child: Text("Instagram")),
                      ],
                     )

                    ]),
                ),
              );
            }));
         },
         //infoWindow: InfoWindow(title: Data.info[i][0] as String)
         
        )
      );
    }
    return markers;
  }

  
    MapType _mapTyp = MapType.normal;

  @override
  Widget build(BuildContext context) {
    CameraPosition hajime = CameraPosition(
      bearing: 100.8334901395799,
      target: LatLng(43.19778423401705, 140.99369049999996),//最初の位置ここで指定する
      tilt: 1.440717697143555,
      zoom: 17.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:GoogleMap(
        mapType: _mapTyp,
        markers: _createMarker(),
        zoomControlsEnabled: false,
        /*
        onTap: (position){
          _customWindowController.hideInfoWindow!();
        },
        */
        initialCameraPosition: hajime,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          if(_mapTyp == MapType.normal)
          {
            _mapTyp = MapType.satellite;
          }else
          {
            _mapTyp = MapType.normal;
          }
        });
      },),
    );
  }
}
