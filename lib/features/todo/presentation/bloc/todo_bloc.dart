import 'package:bloc/bloc.dart';
import 'package:demo/features/todo/data/dto/todo_dto.dart';
import 'package:demo/features/todo/data/entities/todo.dart';
import 'package:demo/features/todo/domain/enums/todo_status.dart';
import 'package:demo/features/todo/domain/repo/todo_repository.dart';
import 'package:equatable/equatable.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _repository;
  TodoBloc(this._repository) : super(TodoState.initial()) {
    on<TodoEvent>((event, emit) {
      return switch (event) {
        _Init() => _init(event, emit),
        _Add() => _add(event, emit),
        _Update() => _update(event, emit),
        _Delete() => _delete(event, emit),
      };
    });
  }

  Future<void> _init(_Init event, Emitter<TodoState> emit) async {
    final todos = await _repository.getAllTodos();
    emit(state.copyWith(todos: [...todos]));
  }

  Future<void> _add(_Add event, Emitter<TodoState> emit) async {
    try {
      final newTodo = await _repository.addTodo(AddTodoDto(name: event.name));
      final nState = [...?state.todos, newTodo];
      emit(state.copyWith(todos: [...nState], status: TodoStatus.added));
    } catch (_) {
      emit(state.copyWith(status: TodoStatus.addFailed));
    } finally {
      emit(state.copyWith(status: null));
    }
  }

  Future<void> _update(_Update event, Emitter<TodoState> emit) async {
    final success = await _repository.updateTodo(
      UpdateTodoDto(id: event.id, name: event.updatedName),
    );
    if (success) {
      emit(state.copyWith(status: TodoStatus.updated));
      add(TodoEvent.init());
    } else {
      emit(state.copyWith(status: TodoStatus.updateFailed));
    }
    emit(state.copyWith(status: null));
  }

  Future<void> _delete(_Delete event, Emitter<TodoState> emit) async {
    final success = await _repository.deleteTodo(event.id);
    if (success) {
      emit(state.copyWith(status: TodoStatus.deleted));
      add(TodoEvent.init());
    } else {
      emit(state.copyWith(status: TodoStatus.deleteFailed));
    }
    emit(state.copyWith(status: null));
  }
}
