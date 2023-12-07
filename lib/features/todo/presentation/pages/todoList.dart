import 'package:flutter/material.dart';
import 'package:mytodolist/features/auth/repository/authrepository.dart';
import 'package:mytodolist/features/todo/model/todo.model.dart';
import 'package:mytodolist/features/todo/presentation/pages/addTodo.dart';
import 'package:mytodolist/features/todo/repository/todo.repository.dart';
import 'package:mytodolist/features/auth/model/auth.model.dart';

class TodoListPage extends StatefulWidget {
  final AuthModel authModel;

  const TodoListPage({Key? key, required this.authModel}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isloading = false;
  late AuthRepository authRepository;
  late TodoRepository todoRepository;
  late ScaffoldMessengerState snackbar;
  List<TodoModel> todoList = [];

  @override
  void initState() {
    super.initState();
    authRepository = AuthRepository();
    todoRepository = TodoRepository();
    getTodoList();
  }

  void getTodoList() {
    setState(() => isloading = true);

    todoRepository.getTodoList(widget.authModel.userId).then((value) {
      setState(() => isloading = false);

      setState(() => todoList = value);
    }).catchError((e) {
      setState(() => isloading = false);
      snackbar.showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    snackbar = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text('My To Do List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.input),
            onPressed: () {
              setState(() => isloading = true);
              authRepository.logout().then((value) {
                setState(() => isloading = false);
                Navigator.pop(context);
              }).catchError((e) {
                setState(() => isloading = false);
                snackbar.showSnackBar(SnackBar(content: Text(e.toString())));
              });
            },
          )
        ],
      ),
      body: Builder(builder: (context) {
        if (isloading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      final todo = todoList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTodoListPage(
                                authModel: widget.authModel,
                                todoModel: todo,
                              ),
                            ),
                          ).then((value) {
                            getTodoList();
                          });
                        },
                        child: SizedBox(
                          width: 750,
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(todo.title),
                                Checkbox(
                                  value: todo.status,
                                  onChanged: (status) {
                                    setState(() => isloading = true);
                                    todoRepository
                                        .updateStatus(status ?? false, todo.id)
                                        .then((value) {
                                      setState(() => isloading = false);
                                      snackbar.showSnackBar(const SnackBar(
                                          content:
                                              Text('Status has been updated')));
                                      getTodoList();
                                    }).catchError((e) {
                                      setState(() => isloading = false);
                                      snackbar.showSnackBar(
                                        const SnackBar(
                                          content: Text('Status update failed'),
                                        ),
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => AddTodoListPage(
                authModel: widget.authModel,
              ),
            ),
          )
              .then((value) {
            getTodoList();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
