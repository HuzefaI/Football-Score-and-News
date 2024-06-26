import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:sem_project_new/UI%20Pages/PageBody.dart';
import 'package:sem_project_new/SoccerModel.dart';
import 'package:sem_project_new/apiManagerCurrMatch.dart';
import '../LaligaApiManager.dart';
import '../SPL_apiManager.dart';
import '../adsPage.dart';

class HomePageLaliga extends StatefulWidget {
  const HomePageLaliga({super.key});
  @override
  State<HomePageLaliga> createState() => _HomePageStateLaliga();
}

class _HomePageStateLaliga extends State<HomePageLaliga> {
  List<Map<String, dynamic>> leagues = [];
  bool isLoading = true;


  BannerAd? _bannerAd;
  @override
  void initState() {
    super.initState();

    _createBanner();
  }

  void _createBanner() {
    _bannerAd = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId!,
        listener: AdMobService.bannerAdListener,
        request: const AdRequest())
      ..load();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/FBfield.jpg"),
          fit: BoxFit.cover,
        )
        ,),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 30,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            "La Liga",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
        body: FutureBuilder(
          //for premier league
          future: SoccerApiLaliga().getAllMatches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),));
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                    'Error loading data: Error print: ${snapshot.error} error end'),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              return PageBody(context, snapshot.data!);
            } else {
              return Center(
                child: Text('No data available'),
              );
            }
          },
        ),
        bottomNavigationBar: (_bannerAd == null)
            ? Container(
          color: Colors.white,
          height: 60,
          width: 470,)
            : SizedBox(
          height: 60,
          width: 470,
          child: AdWidget(ad: _bannerAd!),
        ),

      ),
    );
  }
}



