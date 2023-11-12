import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../utilities/snack_bar.dart';

class DataController extends GetxController {
  Future<bool> isFetchingCompleted() async {
    try {
      // checking the app internet connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet) {
        //fetching data
        final response =
            await http.get(Uri.parse('https://app.et/devtest/list.json'));
        if (response.statusCode == 200) {
          print(response.body);
          return true;
        }
        return false;
      } else {
        showSnackbar('No Internet Connection',
            'Pls Connect to Internet, and Try Again!');
        return false;
      }
    } catch (error) {
      showSnackbar('Failed', '$error');
    }
    return false;
  }
}
