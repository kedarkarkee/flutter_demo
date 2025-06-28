import 'package:demo/core/locator/locator.dart';
import 'package:demo/features/todo/data/entities/todo.dart';
import 'package:demo/features/todo/domain/enums/todo_status.dart';
import 'package:demo/features/todo/domain/repo/todo_repository.dart';
import 'package:demo/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoBloc(locator<TodoRepository>())..add(TodoEvent.init()),
      child: BlocListener<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state.status case final status?) {
            final msg = switch (status) {
              TodoStatus.added => 'Todo added successfully',
              TodoStatus.updated => 'Todo updated successfully',
              TodoStatus.deleted => 'Todo deleted successfully',
              TodoStatus.addFailed => 'Failed to add todo',
              TodoStatus.updateFailed => 'Failed to update todo',
              TodoStatus.deleteFailed => 'Failed to delete todo',
            };

            /// Task was to show dialog but snackbar is shown
            /// Dialog can be similarly shown here
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(msg),
                  backgroundColor: status.isError ? Colors.red : Colors.green,
                ),
              );
          }
        },
        listenWhen: (previous, current) => previous.status != current.status,
        child: Scaffold(
          appBar: AppBar(title: Text('Todo Page')),
          body: BlocSelector<TodoBloc, TodoState, List<TodoEntity>?>(
            selector: (state) => state.todos,
            builder: (context, todos) {
              if (todos == null) {
                return Center(child: CircularProgressIndicator());
              }
              if (todos.isEmpty) {
                return Center(child: Text('No todos found'));
              }
              return ListView.separated(
                itemCount: todos.length,
                separatorBuilder: (_, _) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    title: Text(todo.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            final updatedTodoName =
                                await showModalBottomSheet<String>(
                                  context: context,
                                  builder: (context) {
                                    return _TodoAddDialog(todo: todo);
                                  },
                                );
                            if (updatedTodoName == null || !context.mounted) {
                              return;
                            }
                            context.read<TodoBloc>().add(
                              TodoEvent.update(
                                id: todo.id,
                                updatedName: updatedTodoName,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            context.read<TodoBloc>().add(
                              TodoEvent.delete(id: todo.id),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton(
                onPressed: () async {
                  final todoName = await showModalBottomSheet<String>(
                    context: context,
                    builder: (context) {
                      return _TodoAddDialog();
                    },
                  );
                  if (todoName == null || !context.mounted) {
                    return;
                  }
                  context.read<TodoBloc>().add(TodoEvent.add(name: todoName));
                },
                child: Icon(Icons.add),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TodoAddDialog extends StatefulWidget {
  final TodoEntity? todo;

  const _TodoAddDialog({this.todo});
  @override
  State<_TodoAddDialog> createState() => _TodoAddDialogState();
}

class _TodoAddDialogState extends State<_TodoAddDialog> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameController;

  bool get isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController(text: widget.todo?.name);
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditing ? 'Update todo' : 'Add todo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextFormField(
              autofocus: true,
              controller: nameController,
              decoration: InputDecoration(labelText: 'Todo Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter todo name';
                }
                return null;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    final name = nameController.text;
                    Navigator.of(context).pop(name);
                  },
                  child: isEditing ? Text('Update') : Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
