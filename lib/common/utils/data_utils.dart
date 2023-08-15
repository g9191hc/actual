import 'dart:convert';

import '../const/data.dart';

class DataUtils{
  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static List<String> listPathsToUrls(List paths){
    return paths.map((e) => pathToUrl(e)).toList();
  }

  static String plainToBse64(String plain){
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final encoded = stringToBase64.encode(plain);
    return encoded;
  }

  static DateTime stringToDateTime(String value){
    print('value : $value');
    print(DateTime.parse(value));
    return DateTime.parse(value);
  }
}