class CustomResponse<DataResponse> {
  int status = 0;
  DataResponse data;
  CustomResponse(this.status, this.data);
}

class CustomMessageResponse<DataResponse> {
  bool success = false;
  DataResponse message;
  int? status;
  CustomMessageResponse(this.success, this.message, {this.status = 200});
}

abstract class CustomModelResponse {
  fromMap(Map<String, dynamic> mapObj);
}
