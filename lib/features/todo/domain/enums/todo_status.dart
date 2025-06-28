enum TodoStatus {
  added(),
  updated(),
  deleted(),
  addFailed(isError: true),
  updateFailed(isError: true),
  deleteFailed(isError: true);

  const TodoStatus({this.isError = false});
  final bool isError;
}
