import 'package:scoped_model/scoped_model.dart';
import 'package:meta/meta.dart';

class User {
  final String name;
  final String token;

  User({@required this.name, @required this.token});
}

class AppScoppedModel extends Model {
  User user;
  String errorMessage = "";
  void signIn({String username, String password}) {
    if (username == 'abc' && password == 'abc') {
      user = User(name: username, token: 'dummy token');
      errorMessage = "";
    } else {
      errorMessage = "User name or Password are invalid. Please try again";
    }

    print("The new error message: $errorMessage");
    notifyListeners();
  }

  String getErrorMessage() {
    return errorMessage;
  }
}
