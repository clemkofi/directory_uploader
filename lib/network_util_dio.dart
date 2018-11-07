import 'package:dio/dio.dart';

class NetworkUtilDuo {
  var dio = new Dio();

  // function to do the posting of data
  postData(String url, {Map headers, body}) async {
    // make form data with the body that would be formated in json and passed in
    FormData formData = new FormData.from(body);

    // 
    Response response = await dio.post(url, data: formData, options: Options(headers: headers));
    print(response.data);
  }
  
}