import 'package:flutter/material.dart';
import 'backend/api_requests/api_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      _Notes = await secureStorage.getStringList('ff_Notes') ?? _Notes;
    });
    await _safeInitAsync(() async {
      _isPageSelected = (await secureStorage.getStringList('ff_isPageSelected'))
              ?.map(int.parse)
              .toList() ??
          _isPageSelected;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  LatLng? _location = LatLng(25.4358011, 81.846311);
  LatLng? get location => _location;
  set location(LatLng? value) {
    _location = value;
  }

  List<String> _Notes = [];
  List<String> get Notes => _Notes;
  set Notes(List<String> value) {
    _Notes = value;
    secureStorage.setStringList('ff_Notes', value);
  }

  void deleteNotes() {
    secureStorage.delete(key: 'ff_Notes');
  }

  void addToNotes(String value) {
    Notes.add(value);
    secureStorage.setStringList('ff_Notes', _Notes);
  }

  void removeFromNotes(String value) {
    Notes.remove(value);
    secureStorage.setStringList('ff_Notes', _Notes);
  }

  void removeAtIndexFromNotes(int index) {
    Notes.removeAt(index);
    secureStorage.setStringList('ff_Notes', _Notes);
  }

  void updateNotesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    Notes[index] = updateFn(_Notes[index]);
    secureStorage.setStringList('ff_Notes', _Notes);
  }

  void insertAtIndexInNotes(int index, String value) {
    Notes.insert(index, value);
    secureStorage.setStringList('ff_Notes', _Notes);
  }

  List<int> _isPageSelected = [];
  List<int> get isPageSelected => _isPageSelected;
  set isPageSelected(List<int> value) {
    _isPageSelected = value;
    secureStorage.setStringList(
        'ff_isPageSelected', value.map((x) => x.toString()).toList());
  }

  void deleteIsPageSelected() {
    secureStorage.delete(key: 'ff_isPageSelected');
  }

  void addToIsPageSelected(int value) {
    isPageSelected.add(value);
    secureStorage.setStringList(
        'ff_isPageSelected', _isPageSelected.map((x) => x.toString()).toList());
  }

  void removeFromIsPageSelected(int value) {
    isPageSelected.remove(value);
    secureStorage.setStringList(
        'ff_isPageSelected', _isPageSelected.map((x) => x.toString()).toList());
  }

  void removeAtIndexFromIsPageSelected(int index) {
    isPageSelected.removeAt(index);
    secureStorage.setStringList(
        'ff_isPageSelected', _isPageSelected.map((x) => x.toString()).toList());
  }

  void updateIsPageSelectedAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    isPageSelected[index] = updateFn(_isPageSelected[index]);
    secureStorage.setStringList(
        'ff_isPageSelected', _isPageSelected.map((x) => x.toString()).toList());
  }

  void insertAtIndexInIsPageSelected(int index, int value) {
    isPageSelected.insert(index, value);
    secureStorage.setStringList(
        'ff_isPageSelected', _isPageSelected.map((x) => x.toString()).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
