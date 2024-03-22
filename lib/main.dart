import 'dart:async';
import 'dart:convert';
import 'package:crypto_currency_data_fetch/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'data_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //create stream
  final apiController = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Obx(
          () =>  StreamBuilder<DataModel>(
          stream: apiController.streamController.value.stream,
          builder: (context,snapdata){
             switch(snapdata.connectionState){
               case ConnectionState.waiting: return Center(child: CircularProgressIndicator(),);
               default: if(snapdata.hasError){
                 return Text('Please Wait....');
               }else{
                 return BuildCoinWidget(snapdata.data!);
               }
             }
          },
        ),
        )
      ),
    );
  }

  Widget BuildCoinWidget(DataModel dataModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${dataModel.tokenName}',style: TextStyle(fontSize: 25),),
          SizedBox(height: 20,),
          dataModel.tokenLogo != null ?
          Image.network('${dataModel.tokenLogo}',width: 150,height: 150,):CircularProgressIndicator(),
          SizedBox(height: 20,),
          Text('\$ ${dataModel.usdPrice}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          SizedBox(height:30),
          ElevatedButton(onPressed: (){apiController.getCryptoPrice();}, child: Text("Refresh"))
        ],
      ),
      
    );
  }
}