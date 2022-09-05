class CustomResponse {
  int status = 0;
  dynamic data;
  CustomResponse(this.status, this.data);
}

class CustomMessageResponse {
  bool success = false;
  dynamic message = "";
  CustomMessageResponse(this.success, this.message);
}
