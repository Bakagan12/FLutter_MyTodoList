// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mytodolist/features/auth/model/auth.model.dart';
// ignore: unused_import
import 'package:mytodolist/features/todo/presentation/pages/todoList.dart';
import 'package:mytodolist/features/todo/repository/todo.repository.dart';
import 'package:mytodolist/features/todo/model/todo.model.dart';
import 'package:mytodolist/guard.dart';

class AddTodoListPage extends StatefulWidget {
  const AddTodoListPage({Key? key, required this.authModel, this.todoModel})
      : super(key: key);

  final AuthModel authModel;
  final TodoModel? todoModel;

  @override
  State<AddTodoListPage> createState() => _AddTodoListPageState();
}

class _AddTodoListPageState extends State<AddTodoListPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();

  late TodoRepository todoRepository;
  late ScaffoldMessengerState snackbar;
  bool isloading = false;
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    todoRepository = TodoRepository();
    isUpdate = widget.todoModel != null;

    if (isUpdate) {
      titlecontroller.text = widget.todoModel?.title ?? '';
      descriptioncontroller.text = widget.todoModel?.description ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    snackbar = ScaffoldMessenger.of(context);

    return Scaffold(
      backgroundColor: Colors.lightBlue,
      appBar: AppBar(
        title: isUpdate ? const Text('Update Todo') : const Text('Add To Do'),
      ),
      body: Builder(
        builder: (context) {
          if (isloading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 600,
                      child: TextFormField(
                        controller: titlecontroller,
                        decoration: const InputDecoration(
                          hintText: 'Enter a Title',
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Guard.validateTitle(
                                value, 'Title is Required');
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 600,
                      child: TextFormField(
                        controller: descriptioncontroller,
                        decoration: const InputDecoration(
                          hintText: 'Enter a Description',
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 600,
                      height: 50,
                      child: Visibility(
                        visible: !isUpdate,
                        child: ElevatedButton(
                          child: const Text('Add'),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              setState(() => isloading = true);

                              todoRepository
                                  .createTodo(
                                widget.authModel.userId,
                                descriptioncontroller.text,
                                titlecontroller.text,
                              )
                                  .then((value) {
                                setState(() => isloading = false);

                                snackbar.showSnackBar(const SnackBar(
                                  content: Text('Todo has been created'),
                                ));

                                Navigator.pop(context);
                              }).catchError((e) {
                                setState(() => isloading = false);

                                snackbar.showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isUpdate,
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() => isloading = true);

                              todoRepository
                                  .updateTodo(
                                widget.todoModel!.id,
                                descriptioncontroller.text,
                                titlecontroller.text,
                              )
                                  .then((value) {
                                setState(() => isloading = false);

                                snackbar.showSnackBar(const SnackBar(
                                  content: Text('Todo has been Updated'),
                                ));

                                Navigator.pop(context);
                              }).catchError((e) {
                                setState(() => isloading = false);

                                snackbar.showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              });
                            },
                            child: const Text('Update'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() => isloading = true);

                              todoRepository
                                  .deleteTodo(
                                widget.todoModel!.id,
                              )
                                  .then((value) {
                                setState(() => isloading = false);

                                snackbar.showSnackBar(const SnackBar(
                                  content: Text('Todo has been Deleted'),
                                ));

                                Navigator.pop(context);
                              }).catchError((e) {
                                setState(() => isloading = false);

                                snackbar.showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              });
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
