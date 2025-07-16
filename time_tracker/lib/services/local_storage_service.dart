import 'package:localstorage/localstorage.dart';

void main() async {
  final storage = LocalStorage(
    'my_app',
    storage: FlutterLocalStorage(),
  ); // Use FlutterLocalStorage as the concrete implementation
  await storage.ready;
  storage.setItem('foo', 'bar');
  print(storage.getItem('foo')); // Should print 'bar'
}
