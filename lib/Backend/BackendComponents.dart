// General Components used for the application

class BackendComponents {

  Future<dynamic> getValueForKey(String key, Map<String, dynamic> map){

    // Gets value for key title
    final data = map[key];
    return data;
  }
}