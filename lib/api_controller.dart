import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'data_model.dart';

class ApiController extends GetxController {
  // Create a reactive stream controller
  final streamController = Rx(StreamController<DataModel>.broadcast());
  var _timer;

  @override
  void onInit() {
    super.onInit();
       getCryptoPrice();
    // A Timer method that runs every 
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      getCryptoPrice();
    });
  }


  // A method to fetch data from the API
  Future<void> getCryptoPrice() async {
   
     try {
       var url = Uri.parse(
        'https://deep-index.moralis.io/api/v2.2/erc20/0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599/price?chain=eth&include=percent_change');

    final response = await http.get(url, headers: {
      'accept': 'application/json',
      'X-Api-key':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJub25jZSI6IjMyYjlmNWRkLTgyNWQtNGVmYi05MWFjLWE3MjhjNDAzMjZhZiIsIm9yZ0lkIjoiMzgzODQ1IiwidXNlcklkIjoiMzk0NDA3IiwidHlwZUlkIjoiNzNlNmYyZmYtYWIyZC00MDdmLThiOGItODRjZmI2ZmQwMWJhIiwidHlwZSI6IlBST0pFQ1QiLCJpYXQiOjE3MTA5NTQ0MjgsImV4cCI6NDg2NjcxNDQyOH0.O4DAP1IUynDW-77KnZdTTPotO00VN06o5LeusfAXvXs'
    });

    final databody = json.decode(response.body);
   
      if (response.statusCode == 200) {
        DataModel dataModel = DataModel.fromJson(databody);
        streamController.value.sink.add(dataModel);
       
      } else {
        print("API request failed with status code ${response.statusCode}");
      }
    } catch (e) {
      print("Exception occurred: $e");
    }
  }
  

  @override
  void onClose() {
    // Stop streaming when the app is closed
    streamController.value.close();
     _timer?.cancel();
    super.onClose();
  }
}
