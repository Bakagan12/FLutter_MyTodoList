import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mytodolist/features/auth/model/auth.model.dart';

class AuthRepository {
  late Client client;
  late Account account;
  late FlutterSecureStorage secureStorage;

  AuthRepository() {
    Client client = Client();
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('6538f224c3c1218b4a9b')
        .setSelfSigned(
            status:
                true); // For self signed certificates, only use for development

    //Initialize the account
    account = Account(client);

    //initialize secureStorage
    secureStorage = const FlutterSecureStorage();
  }

  Future<void> register(String email, String password) async {
    account.create(userId: ID.unique(), email: email, password: password);
  }

  Future<AuthModel> login(String email, String password) async {
    ///Create session using email
    final Session session = await account.createEmailSession(
      email: email,
      password: password,
    );

    ///Save sessionId in secure storage
    await secureStorage.write(key: 'SESSION_ID', value: session.$id);

    /// get user details
    final User user = await account.get();

    ///Return AuthModel object
    return AuthModel(email: user.email, userId: user.$id);
  }

  Future<void> logout() async {
    ///Find sessionId from secureStorage
    String? sessionId = await secureStorage.read(key: 'SESSION_ID');

    /// if SessionId is null then return
    if (sessionId == null) return null;

    ///Delete Session from appwrite
    await account.deleteSession(
      sessionId: sessionId,
    );

    ///Delete SessionId from secureStorage
    await secureStorage.delete(key: 'SESSION_ID');
  }

  Future<AuthModel?> autologin() async {
    ///Find sessionId from secure storage
    String? sessionId = await secureStorage.read(key: 'SESSION_ID');

    /// If session id is null, then return null
    if (sessionId == null) return null;

    /// Get Session using sessionId
    await account.getSession(
      sessionId: sessionId,
    );

    /// Get user details
    final User user = await account.get();
    print('User ID: ${user.$id}');

    /// Return AuthModel object
    return AuthModel(email: user.email, userId: user.$id);
  }
}
