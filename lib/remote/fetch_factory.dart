
import 'dart:convert' as convert;
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:kcbweb_account_manage/common/tip_helper.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/remote/fetch_config.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';


class FetchFactory {

  static const String TAG = "Remoter -- ";
  static Map<String, String> headers = { 'token':'', 'Content-type':'application/json', 'pikav':'2.3.10' };

  /// Action
  static RemoteData generateResData(http.Response response, String path){
    if(response == null)  {
      Logger.e('the path -->> $path -- response null', tag: TAG);
      TipHelper.toast(msg:'网络连接异常，请稍后重试');
      return null;
    }
    else {
      try {
        if(response.statusCode == 200) {
          var jsonRes = convert.jsonDecode(response.body);
          int errorCode = jsonRes['statusCode'];

          Logger.i('the path -->> $path -- response statusCode -->> $errorCode', tag: '${TAG}response');
          if(errorCode == 200) {
            return RemoteData(errorCode, jsonRes['message'], jsonRes['data']);
          }
          else {
            String tip;
            String message = jsonRes['message'];
            tip = (message?.isNotEmpty ?? false)? message : '数据获取异常，请稍后重试';
            TipHelper.toast(msg: tip);

            Logger.e('the path -->> $path -- response statusCode -->> $errorCode and message -->> $tip', tag: TAG);
            return null;
          }
        }else {
          TipHelper.toast(msg:'网络连接异常，请稍后重试');
          return null;
        }
      }catch(exception){
        Logger.e('000 generateResData -->> $exception', tag: TAG);
        return null;
      }
    }
  }

  static _generatePath(String path, String version, Map params){
    String url;

    if(version?.isNotEmpty ?? false) url = '$SERVICE_URL/api/$version/app/$path';
    else url = '$SERVICE_URL$API_PRE$path';

    Logger.i("the fetch url -->> $url and the parsms -->> ${convert.jsonEncode(params)}", tag: '${TAG}fetch');
    return url;
  }

  /// Method Factory
  static get (String url, { String version, Map params }) async {
    String path = _generatePath(url, version, params);
    if(params?.isNotEmpty ?? false) {
      StringBuffer sb = new StringBuffer('?');
      params.forEach((key, value) { sb.write('$key=$value&'); });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      path += paramStr;
    }

    try {
      http.Response response = await http.get(path, headers: headers);
      return generateResData(response, path);
    }catch (exception){
      Logger.e('000000 GET exception -->> $exception', tag: TAG);
      return generateResData(null, null);
    }
  }

  static post (String url, { String version, Map params}) async {
    String path = _generatePath(url, version, params);


    try{
      var body = (params?.isNotEmpty ?? false)? convert.jsonEncode(params) : convert.jsonEncode({});
      http.Response response = await http.post(path, headers: headers, body:body);
      return generateResData(response, path);
    }catch(exception){
      Logger.e('000000 POST exception -->> $exception');
      return generateResData(null, null);
    }
  }

}