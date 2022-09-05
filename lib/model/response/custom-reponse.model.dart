class CustomResponse<DataResponse> {
  int status = 0;
  DataResponse data;
  CustomResponse(this.status, this.data);
}

class CustomMessageResponse<DataResponse> {
  bool success = false;
  DataResponse message;
  CustomMessageResponse(this.success, this.message);
}

abstract class CustomModelResponse {
  fromMap(Map<String, dynamic> mapObj);
}
