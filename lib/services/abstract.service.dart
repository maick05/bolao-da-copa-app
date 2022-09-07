// ignore_for_file: avoid_print

import 'package:bolao_da_copa/model/response/custom-reponse.model.dart';

abstract class AbstractService {
  static CustomMessageResponse validateGetResponse<ResponseListType>(
      CustomResponse response,
      String action,
      CustomModelResponse objectResponse,
      {bool list = true}) {
    switch (response.status) {
      case 200:
      case 201:
      case 202:
      case 203:
      case 204:
        return CustomMessageResponse(
            true,
            AbstractService.makeFromMap<ResponseListType>(
                response.data, objectResponse, list));
      default:
        return CustomMessageResponse(
            false, "Erro ao " + action + ": " + response.data['message']);
    }
  }

  static dynamic makeFromMap<ResponseListType>(
      dynamic dataMap, CustomModelResponse objectResp, bool list) {
    if (dataMap == null || dataMap.isEmpty) return list ? [] : null;

    if (!list) return objectResp.fromMap(dataMap);

    List<ResponseListType> listResp = [];
    dynamic obj;

    for (var i = 0; i < dataMap.length; i++) {
      obj = objectResp;
      var objMap = obj.fromMap(dataMap[i]);
      listResp.add(objMap);
      obj = null;
    }

    return listResp;
  }
}
