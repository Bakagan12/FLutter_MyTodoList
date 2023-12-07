// ignore: unused_import
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:appwrite/appwrite.dart';
import 'package:mytodolist/features/todo/model/todo.model.dart';

class TodoRepository {
  late Client client;
  late Databases databases;

  TodoRepository() {
    client = Client();

    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('6538f224c3c1218b4a9b')
        .setSelfSigned(status: true);

    databases = Databases(client);
  }
  Future<List<TodoModel>> getTodoList(String userId) async {
    ///Get Todo List From Appwrite
    final docs = await databases.listDocuments(
      databaseId: '654b683b364e8b9e72b2',
      collectionId: '654b68529e36f8f90de2',
      queries: [
        Query.equal('createdBy', userId),
      ],
    );

    final List<TodoModel> result = [];

    ///Loop Documents and convert to TodoModel
    for (int i = 0; i < docs.documents.length; i++) {
      ///Get Specific document
      final document = docs.documents[i];

      ///Convert to TodoModel
      final todoModel = TodoModel(
        id: document.$id,
        title: document.data['title'],
        description: document.data['description'],
        status: document.data['status'],
        createdBy: document.data['createdBy'],
      );

      result.add(todoModel);
    }

    ///Return TodoModel List
    return result;
  }

  Future<void> createTodo(
      String userId, String description, String title) async {
    /// create Tdod

    await databases.createDocument(
      databaseId: '654b683b364e8b9e72b2',
      collectionId: '654b68529e36f8f90de2',
      documentId: ID.unique(),
      data: {
        'title': title,
        'description': description,
        'createdBy': userId,
      },
    );
  }

  Future<void> updateStatus(bool status, String todoId) async {
    ///Update Todo status
    await databases.updateDocument(
      databaseId: '654b683b364e8b9e72b2',
      collectionId: '654b68529e36f8f90de2',
      documentId: todoId,
      data: {
        'status': status,
      },
    );
  }

  Future<void> updateTodo(
      String title, String description, String todoId) async {
    await databases.updateDocument(
      databaseId: '654b683b364e8b9e72b2',
      collectionId: '654b68529e36f8f90de2',
      documentId: todoId,
      data: {
        'title': title,
        'description': description,
      },
    );
  }

  Future<void> deleteTodo(String todoId) async {
    print(todoId);
    await databases.deleteDocument(
      databaseId: '654b683b364e8b9e72b2',
      collectionId: '654b68529e36f8f90de2',
      documentId: todoId,
    );
  }
}
