sealed class ApiResult<T, E extends Exception> {
  const ApiResult();
}

class SuccessRequest<T, E extends Exception> extends ApiResult<T, E> {
  final T data;

  const SuccessRequest({required this.data});
}

class FailedRequest<T, E extends Exception> extends ApiResult<T, E> {
  final E exception;

  const FailedRequest({required this.exception});
}

