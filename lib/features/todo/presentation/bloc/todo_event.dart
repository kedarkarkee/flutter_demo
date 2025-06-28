part of 'todo_bloc.dart';

sealed class TodoEvent {
  const TodoEvent();
  factory TodoEvent.init() = _Init;
  factory TodoEvent.add({required String name}) = _Add;
  factory TodoEvent.update({required int id, required String updatedName}) =
      _Update;
  factory TodoEvent.delete({required int id}) = _Delete;
}

class _Init extends TodoEvent {}

class _Add extends TodoEvent {
  final String name;

  const _Add({required this.name});
}

class _Update extends TodoEvent {
  final int id;
  final String updatedName;

  const _Update({required this.id, required this.updatedName});
}

class _Delete extends TodoEvent {
  final int id;

  _Delete({required this.id});
}
