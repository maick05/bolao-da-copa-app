class CustomResponse<DataResponse> {
  int status = 0;
  DataResponse data;
  CustomResponse(this.status, this.data);
}

class CustomMessageResponse {
  bool success = false;
  dynamic message = "";
  CustomMessageResponse(this.success, this.message);
}
