// This class is a single instance class that other files can access it's variables and functions
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ndy/FrontEnd/MediaUploadFlows/AlbumSongsDisplayUploadView.dart';
import 'package:ndy/FrontEnd/MenuFlow/CommentView.dart';
import 'package:ndy/FrontEndComponents/ButtonComponents.dart';
import 'package:provider/provider.dart';
import '../FrontEnd/MainAppFlows/Profile.dart';
import '../FrontEnd/MediaUploadFlows/SinglesCoverDisplay.dart';
import '../FrontEnd/MenuFlow/LikedSongsView.dart';
import '../FrontEndComponents/AudioComponents.dart';
import '../FrontEndComponents/TextComponents.dart';
import 'GlobalComponents.dart';
import 'package:palette_generator/palette_generator.dart';


class FirebaseComponents {

  // This ensures there is only one instance of the class, multiple copies can not be made 
  // Singleton instance
  static final FirebaseComponents _instance = FirebaseComponents._internal();

  static final firebaseFirestore = FirebaseFirestore.instance;
  static final firebaseStorage = FirebaseStorage.instance.ref();
  static final timeStampData = DateTime.now();

  // Private constructor
  FirebaseComponents._internal();

  // Factory constructor to access the instance
  factory FirebaseComponents() => _instance;


  // These funcs are async
  // Get a single piece of data from firestore ( int )
  Future<int?> fetchDataFromFirestoreInt(String path) async {
    //try / catch 
    try {

      final DocumentSnapshot snapshot = await firebaseFirestore.doc(path).get();

      if (snapshot.exists){
        // Fetches the data and parses it as an int
        final int data = snapshot.data() as int;
        return data;
      } else {
        // If snapshot does not exist
        return null;
      }
    } catch (e) {
      //failure in try / catch
      print(e);
      return null;
    }
  }

Future<bool> deleteSong(String documentID, String documentPath, String collectionPath, String tagType, List<dynamic> tags, String title) async {
  try {
    // Get a reference to the Firestore instance
    final firestore = FirebaseFirestore.instance;
    final firebaseStorage = FirebaseStorage.instance;

    // Fetch the document to get the list of download URLs
    DocumentSnapshot docSnapshot = await firestore.doc(documentPath).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      if (data.containsKey('image_urls')) {
        List<String> downloadURLs = List<String>.from(data['image_urls']);

        // Delete the song media from Firebase Storage
        for (var url in downloadURLs) {
          var fileRef = firebaseStorage.refFromURL(url);
          await fileRef.delete();
        }
      }
    }

    // Delete the document from Firestore
    await firestore.doc(documentPath).delete();

    // Delete the reference from the main collection
    await firestore.collection(collectionPath).doc(documentID).delete();

    // Delete the subcollections manually
    for (String tag in tags) {
      String tagCollectionPath = 'tags/$tag/collection/$documentID';
      CollectionReference subcollection = firestore.collection(tagCollectionPath);
      QuerySnapshot querySnapshot = await subcollection.get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    }

    // Manually delete from the mix tag collection
    String mixTagCollectionPath = 'tags/mix/collection/$documentID';
    CollectionReference mixSubcollection = firestore.collection(mixTagCollectionPath);
    QuerySnapshot mixQuerySnapshot = await mixSubcollection.get();

    for (DocumentSnapshot doc in mixQuerySnapshot.docs) {
      await doc.reference.delete();
    }

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}



  Future<void> updateSpecificField({required String documentPath, required Map<String, dynamic> newData}) async {
    try {
      await FirebaseFirestore.instance.doc(documentPath).update(newData);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }


  Future<void> setPin(String postReferencePath, int position) async {// Assuming you have this global variable

  DocumentReference docRef = firebaseFirestore.doc('users/${GlobalVariables.userUUID}');

  await docRef.get().then((doc) {
    if (doc.exists) {
      List<dynamic> pinned = doc['pinned'];
      print(pinned);
      if (pinned.length > position) {
        pinned[position] = postReferencePath;
      } else {
        pinned.add(postReferencePath);
      }
      docRef.update({'pinned': pinned});
      print('done');
    }
  });
}

Future<List<Map<String, dynamic>>> getLatestTextAndPostFromCollection({required String collectionPath}) async {
    print("hey");
    var textDocSnapshot = await firebaseFirestore.collection(collectionPath)
        .orderBy('timestamp', descending: true)
        .where('type', isEqualTo: 'thought') // Use type field
        .limit(1)
        .get();

    var postDocSnapshot = await firebaseFirestore.collection(collectionPath)
        .orderBy('timestamp', descending: true)
        .where('type', isEqualTo: 'post') // Use type field
        .limit(1)
        .get();


    var latestDocuments = [
      {"text": textDocSnapshot.docs.isNotEmpty ? textDocSnapshot.docs.first.data() : null},
      {"post": postDocSnapshot.docs.isNotEmpty ? postDocSnapshot.docs.first.data() : null},
    ];

    return latestDocuments;
}



// Get data 
Future<Map<String, dynamic>> getSpecificData(
  {required String documentPath, List<String>? fields}) async {
// Get a DocumentReference
DocumentReference docRef = firebaseFirestore.doc(documentPath);
print(docRef);

// Get the document
DocumentSnapshot docSnapshot = await docRef.get();

if (docSnapshot.exists) {
  // Get the document data
  Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

  // Filter the data to only include the required fields
  if (fields != null) {
    Map<String, dynamic> filteredData = {};
    for (String field in fields) {
      if (data.containsKey(field)) {
        filteredData[field] = data[field];
      }
    }
    return filteredData;
  } else {
    // If fields is null, return all data
    return data;
  }
} else {
  throw Exception('Document does not exist');
}
}

Future<Map<String, dynamic>> getSpecialData(
  {required String documentPath}) async {
// Get a DocumentReference
DocumentReference docRef = firebaseFirestore.doc(documentPath);
// Get the document
DocumentSnapshot docSnapshot = await docRef.get();

if (docSnapshot.exists) {
  // Get the document data
  Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;


    // If fields is null, return all data
  return data;
  } else {

    return {};
  }
}


Future<List<Map<String, dynamic>>> getCollectionData({ 
  required String collectionPath, 
  List<String>? fields,
  int? limit
}) async {
  // Get a CollectionReference
  CollectionReference colRef = firebaseFirestore.collection(collectionPath);

  // If a limit has been set, then limit the number of documents to be retrieved.
  QuerySnapshot querySnapshot;
  if(limit != null){
    querySnapshot = await colRef.limit(limit).get();
  } else {
    querySnapshot = await colRef.get();
  }

  // Get the data for each document in the collection
  List<Map<String, dynamic>> allData = [];
  for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

    // If fields are not null then filter the data to only include the required fields
    // Else add the entire data
    if (fields != null) {
      Map<String, dynamic> filteredData = {};
      for (String field in fields) {
        if (data.containsKey(field)) {
          filteredData[field] = data[field];
        }
      }
      allData.add(filteredData);
    } else {
      allData.add(data);
    }
  }

  return allData;
}

Future<List<Map<String, dynamic>>> getPaginatedCollectionData({ 
  required String collectionPath, 
  List<String>? fields,
  int? limit,
  DocumentSnapshot? startAfterDocument,
}) async {
  // Get a CollectionReference
  CollectionReference colRef = firebaseFirestore.collection(collectionPath);

  // Apply optional pagination parameters if provided
  Query query = colRef;
  if (limit != null) {
    query = query.limit(limit);
  }
  if (startAfterDocument != null) {
    query = query.startAfterDocument(startAfterDocument);
  }

  // Execute the query to get the data
  QuerySnapshot querySnapshot = await query.get();

  // Get the data for each document in the collection
  List<Map<String, dynamic>> allData = [];
  for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

    // If fields are not null then filter the data to only include the required fields
    // Else add the entire data
    if (fields != null) {
      Map<String, dynamic> filteredData = {};
      for (String field in fields) {
        if (data.containsKey(field)) {
          filteredData[field] = data[field];
        }
      }
      allData.add(filteredData);
    } else {
      allData.add(data);
    }
  }

  return allData;
}


  
  Future<Map<String, dynamic>> getLatestDocumentFromCollection({required String collectionPath}) async {
    var docSnapshot = await firebaseFirestore.collection(collectionPath)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (docSnapshot.docs.isNotEmpty) {
      return docSnapshot.docs.first.data();
    } else {
      throw Exception('No documents found in collection $collectionPath');
    }
  }
Future<List<Map<String, dynamic>>> getReferencedData({
  required String collectionPath,
  List<String>? fields,
  int? limit,
  String? T, // Optional string value T
}) async {
  List<Map<String, dynamic>> dataList = [];
  String ref;

  CollectionReference colRef = firebaseFirestore.collection(collectionPath);
  QuerySnapshot snapshot;
  if (limit != null) {
    snapshot = await colRef.limit(limit).get();
  } else {
    snapshot = await colRef.get();
  }
  for (var doc in snapshot.docs) {
    if(T != null){
      ref = doc['ref'].path;
    } else {
      ref = doc['ref'];
    }
    DocumentSnapshot refDocSnapshot = await FirebaseFirestore.instance.doc(ref).get();
    Map<String, dynamic> data = refDocSnapshot.data() as Map<String, dynamic>;

    // Now we have the data, but we only want to keep the fields you're interested in
    Map<String, dynamic> filteredData = {};
    if (fields != null) {
      for (String field in fields) {
        filteredData[field] = data[field];
      }
    } else {
      filteredData = data;
    }

    dataList.add(filteredData);
  }

  return dataList;
}

Future<List<Map<String, dynamic>>> getPaginatedReferencedData({
  required String collectionPath,
  List<String>? fields,
  int? limit,
  DocumentSnapshot? startAfter,
  String? T, // Optional string value T
}) async {
  List<Map<String, dynamic>> dataList = [];
  String ref;
  String text = '';

  CollectionReference colRef = firebaseFirestore.collection(collectionPath);
  QuerySnapshot snapshot;

  Query query = colRef;
  if (limit != null) {
    query = query.limit(limit);
  }
  if (startAfter != null && startAfter.exists) {  // ensure the document snapshot exists before using it
    query = query.startAfterDocument(startAfter);
  }

  snapshot = await query.get();

  for (var doc in snapshot.docs) {
    if(T != null && T != 'R'){
      ref = doc['ref'].path;
      print(ref);
    } else {
      ref = doc['ref'];
      print(ref);
    }

    if(T == 'R'){
      text = doc['text'];
    }
    DocumentSnapshot refDocSnapshot = await FirebaseFirestore.instance.doc(ref).get();
    Map<String, dynamic> data = refDocSnapshot.data() as Map<String, dynamic>;
    
    data['text'] = text;
    // Now we have the data, but we only want to keep the fields you're interested in
    Map<String, dynamic> filteredData = {};
    if (fields != null) {
      for (String field in fields) {
        filteredData[field] = data[field];
      }
    } else {
      filteredData = data;
    }

    dataList.add(filteredData);
  }

  return dataList;
}


Future<Map<String, dynamic>> getReferencedDocumentData({required String documentPath}) async {
  // Get initial document reference
  DocumentReference docRef = FirebaseFirestore.instance.doc(documentPath);
  DocumentSnapshot snapshot = await docRef.get();
  Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

  // Get reference to another document
  String refPath = data['ref'].path;
  DocumentReference refDocRef = FirebaseFirestore.instance.doc(refPath);
  DocumentSnapshot refSnapshot = await refDocRef.get();
  Map<String, dynamic> refData = refSnapshot.data() as Map<String, dynamic>;

  return refData;
}







  // Get a single image from storage ( url )
  Future<String?> fetchImageFromStorageURL(String path) async {

    try {

      final Reference ref = firebaseStorage.child(path);
      // Fetches the data and parses it as a String
      final String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {

      print(e);
      return null;
    }
  }
  // Get a s from storage ( url )
  Future<List<String>?> fetchMediaFromStorageURL(String path) async {
    try {
      DocumentSnapshot documentSnapshot = await firebaseFirestore.doc(path).get();

      List<dynamic> imageUrlListDynamic = documentSnapshot['image_urls'];
      List<String> imageUrlList = imageUrlListDynamic.cast<String>();

      return imageUrlList;
    } catch (e) {
      print(e);
      return null;
    }
  }





  // Set array of data inside of a document, replaces ( firestore )
  Future<bool> setEachDataToFirestore(String path, Map<String, dynamic> data) async {

    data['timestamp'] =  DateTime.now().toString();
    
    try {

      final DocumentReference documentRef = firebaseFirestore.doc(path);
      // Sets the data dynamically, key + value pair
      await documentRef.set(data);
      return true;
    } catch (e) {

      print(e);
      return false;
    }
  }

  // Update with array of data inside of a document, changes ( firestore )
  Future<bool> updateEachDataToFirestore(String path, Map<String, dynamic> data) async {

    data['timestamp'] = timeStampData;
    try {

      final DocumentReference documentRef = firebaseFirestore.doc(path);

      // Updates the document with mergedData
      await documentRef.update(data);
      return true;
    } catch (e) {

      print(e);
      return false;
    }
  }

    Future<void> addDocumentToCollection(String collectionPath, Map<String, dynamic> data,String? documentId) async {
      data['timestamp'] =  DateTime.now().toString();
    CollectionReference collectionReference = firebaseFirestore.collection(collectionPath);
    if (documentId != null) {
      await collectionReference.doc(documentId).set(data).then((_) {
        print("Document added with ID: $documentId");
      }).catchError((error) {
        print("Failed to add document: $error");
      });
    } else {
      await collectionReference.add(data).then((docRef) {
        print("Document added with ID: ${docRef.id}");
      }).catchError((error) {
        print("Failed to add document: $error");
      });
    }
  }

  Future<bool> addDocumentWithTags(String documentID, String documentPath, String tagType, List<String> tags) async {
    // Get a reference to the Firestore instance
    final firestore = firebaseFirestore;

    
    // Add a reference to the document in each tag collection
    for (String tag in tags) {
      await firestore.doc('$tagType/$tag').set({"placeholder" : "null"});
      await firestore.collection('$tagType/$tag/collection').doc(documentID).set({
        'ref': firestore.collection(documentPath).doc(documentID),
        "timestamp": DateTime.now().toString(),
      });
    }

    await firestore.doc('$tagType/mix').set({"placeholder" : "null"});
    for (String tag in tags) {
      await firestore.collection('$tagType/mix/collection').doc(documentID).set({
        'ref': firestore.collection(documentPath).doc(documentID),
        "timestamp": DateTime.now().toString(),
      });
    }

    return true;
  }

    // document name, the reference to the document, and where the reference is going to be placed
    Future<bool> addDocumentRef(String documentID, String documentPath, String collectionPath, String title) async {
    // Get a reference to the Firestore instance
    final firestore = FirebaseFirestore.instance;

    // Add a reference to the document in each tag collection
    await firestore.collection(collectionPath).doc(documentID).set({
      'title' : title,
      'ref': firestore.collection(documentPath).doc(documentID),
      "timestamp": DateTime.now().toString(),
    });


    return true;
  }

Future<bool> replaceAndUploadImage(List<dynamic> imageURLs, String documentPath, String filePath, String oldImageUrl, File newImage, int index) async {
    final storage = FirebaseStorage.instance;
    final firestore = FirebaseFirestore.instance;
    try {
      Reference oldImageRef = storage.refFromURL(oldImageUrl);
      await oldImageRef.delete();

      String imageUUID = GlobalVariables().generateUUID().toString();
      Reference newImageRef = storage.ref('$filePath/$imageUUID.jpg');
      await newImageRef.putFile(newImage);

      String newImageUrl = await newImageRef.getDownloadURL();

      imageURLs[index] = newImageUrl; // replace the old URL with the new one at the same index

      await firestore.doc(documentPath).update({'image_urls': imageURLs});

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

   // Set an array of media inside of a folder ( storage )
  Future<bool> setEachMediaToStorage(String path, String documentPath, Map<String, File> map) async {
    String filePath = '';
    String holder = '';
    List<String> downloadURLs = []; // Array to store the URLs

    try {
      for (var entry in map.entries) {
        // Gets extension type
        holder = Uri.file(entry.value.path).pathSegments.last.split('.').last;
        filePath = '$path/${entry.key}.$holder';
        
        await firebaseStorage
          .child(filePath)
          .putFile(entry.value)
          .then((TaskSnapshot snapshot) async {

            // Retrieve the download URL
            final String downloadURL = await snapshot.ref.getDownloadURL();

            // Add the URL to the list
            downloadURLs.add(downloadURL);

            filePath = '';
            holder = '';
          });
      }

      // Store all download URLs in Firestore under the specified document
      await FirebaseFirestore.instance.doc(documentPath).update({
          'image_urls': FieldValue.arrayUnion(downloadURLs),
      });


      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

Future<bool> deletePost(String documentPath, String collectionPath) async {
  try {
    // Retrieve the document
    final DocumentSnapshot document = await FirebaseFirestore.instance.doc(documentPath).get();

    // Get data and cast to Map
    Map<String, dynamic> docData = document.data() as Map<String, dynamic>;

    // Check if document has 'image_urls' field and it's not null
    if (docData.containsKey('image_urls') && docData['image_urls'] != null) {
      // Delete each media file from Storage
      List<dynamic> downloadURLs = docData['image_urls'];
      for (var url in downloadURLs) {
        String path = extractPathFromUrl(url);
        print(path);
        await FirebaseStorage.instance.ref(path).delete();
      }
    }

    // Delete the document reference from the 'threads' collection
    await FirebaseFirestore.instance.collection(collectionPath).doc(document.id).delete();

    // Delete the documents in the 'likes' subcollection
    QuerySnapshot likesQuerySnapshot = await document.reference.collection('likes').get();
    for (var doc in likesQuerySnapshot.docs) {
      // Delete each document in the subcollection
      await doc.reference.delete();
    }

    // Delete the documents in the 'comments' subcollection
    QuerySnapshot commentsQuerySnapshot = await document.reference.collection('comments').get();
    for (var doc in commentsQuerySnapshot.docs) {
      // Delete each document in the subcollection
      await doc.reference.delete();
    }

    // Finally, delete the document itself
    await document.reference.delete();

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}



String extractPathFromUrl(String url) {
  Uri uri = Uri.parse(url);
  String path = uri.path;

  // '/v0/b/{bucket}/o/{path}'
  // We want to remove the first three segments of the path: ['v0', 'b', '{bucket}', 'o', ...]
  List<String> segments = path.split('/');
  segments.removeRange(0, 5);

  // The path is URL encoded, so we need to decode it
  // Also, remove the query part of the URL
  return Uri.decodeFull(segments.join('/')).split('?').first;
}

Future<void> deleteMood(String documentPath, String collectionPath, List<dynamic> tags) async {
  // Initialize Firebase Firestore and Firebase Storage
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  // Get document ID from documentPath
  final String documentId = documentPath.split('/').last;

  // Delete document in the collectionPath with documentId
  await firestore.collection(collectionPath).doc(documentId).delete();

  // Iterate over tags and delete document in each tag sub-collection
  for (var tag in tags) {
    // Ensure tag is a string
    if (tag is String) {
      await firestore.collection('$collectionPath/$tag/collection').doc(documentId).delete();
    }
  }

  // Delete document in the mix sub-collection with documentId
  await firestore.collection('$collectionPath/mix/collection').doc(documentId).delete();

  // Get document from documentPath
  DocumentSnapshot documentSnapshot = await firestore.doc(documentPath).get();

  // Get image_urls from the document
  List<String> imageUrls = (documentSnapshot.data() as Map<String, dynamic>)['image_urls'].map<String>((item) => item as String).toList();

  // Iterate over imageUrls starting from index 1, delete each
  for (int i = 2; i < imageUrls.length; i++) {
    String imageUrl = imageUrls[i];
    // Extract the file path from the URL
    var urlRegExp = RegExp(r'https://firebasestorage.googleapis.com/v0/b/(.*?)/o/(.*?)\?alt=media.*');
    var match = urlRegExp.firstMatch(imageUrl);
    if (match != null) {
      // Decoding URL encoded path
      String filePath = Uri.decodeFull(match.group(2) ?? '');
      // Delete the file from Firebase Storage
      await storage.ref(filePath).delete();
    }
  }

  // Finally delete the document itself and subcollections (handled by the Cloud Function)
  await firestore.doc(documentPath).delete();
}







  // User sign in 
  Future<bool> signUp(String email, String password) async {

    try {
      
      // Signing up
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } catch (e) {

      print(e);
      return false;
    }
  }

  // Method to update the password
Future<bool> updatePassword(String email, String password, String newPassword) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    print(user);

    // Create credentials
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
    print(credential);

    await user?.reauthenticateWithCredential(credential);
    // Updating password
    await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
  
}

Future<bool> updateEmail(String email, String password, String newEmail) async {
  try {
    // Get the user
    User? user = FirebaseAuth.instance.currentUser;
    print(user);

    // Create credentials
    AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
    print(credential);

    // Reauthenticate
    await user?.reauthenticateWithCredential(credential);

    // Update the email
    await user!.updateEmail(newEmail);
    
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}


// Method to handle forgotten password
Future<bool> forgotPassword(String email) async {
  try {
    // Sending password reset email
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

  // Get Recents ( tags, moods )
  
}

class FirstImageDisplay extends StatelessWidget {
  final String documentPath;

  FirstImageDisplay({required this.documentPath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>?>(
      future: FirebaseComponents().fetchMediaFromStorageURL(documentPath),
      builder: (BuildContext context, AsyncSnapshot<List<String>?> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Text('No images found.');
        } else {
          // Get the first image URL from the list
          String firstImageUrl = snapshot.data!.first;
          return Image.network(firstImageUrl);
        }
      },
    );
  }
}

class FirstImageDisplayFull extends StatelessWidget {
  final String documentPath;

  FirstImageDisplayFull({required this.documentPath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>?>(
      future: FirebaseComponents().fetchMediaFromStorageURL(documentPath),
      builder: (BuildContext context, AsyncSnapshot<List<String>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Text('No images found.');
        } else {
          // Get the first image URL from the list
          String firstImageUrl = snapshot.data!.first;
          return Image.network(firstImageUrl);
        }
      },
    );
  }
}

class CollectionDataDisplay {
  final String collectionPath;
  final List<String> fields;

  CollectionDataDisplay({required this.collectionPath, required this.fields});

  Future<List<Map<String, dynamic>>> getCollectionData() {
    return FirebaseComponents().getCollectionData(
      collectionPath: this.collectionPath,
    );
  }

  Widget displayData() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getCollectionData(),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> docData = snapshot.data![index];
              print(docData);
              return Padding(
                padding: const EdgeInsets.only(
                  left: GlobalVariables.horizontalSpacing,
                  right: GlobalVariables.horizontalSpacing,
                  bottom: 0 // changed the value to GlobalVariables.mediumSpacing
                ),
                child: SongRow(imageUrl: docData['image_urls'][1], songTitle: docData['title'], songArtist: docData['artists'], timestamp: docData['timestamp'], audioUrl: docData['image_urls'][0], albumId: docData['album_id'], userID: docData['user_id'], tags: docData['tags'], barColor: Colors.green, uniqueID: docData['unique_id'])
              );
            },
          );
        }
      },
    );
  }

  

}

class FirestoreService {
  final _firestore = FirebaseComponents.firebaseFirestore;
  DocumentSnapshot? _lastDocument;
  bool _hasMoreData = true;
  String collectionName; // Add collectionName parameter

  FirestoreService(this.collectionName); // Add to constructor

  Future<List<Map<String, dynamic>>> fetchNextBatch() async {
    if (!_hasMoreData) return [];

    Query query = _firestore.collection(collectionName).limit(2); // Use collectionName instead of 'songs'

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshots = await query.get();

    if (snapshots.docs.length < 2) _hasMoreData = false;

    List<Map<String, dynamic>> fetchedData = [];
    for (var doc in snapshots.docs) {
      final String ref = doc['ref'].path;

      final data = await FirebaseComponents().getSpecialData(documentPath: ref);
      print(ref);
      Map<String, dynamic> documentData = data;
      documentData['ref'] = ref; // Add 'ref' parameter to the document data
      Map<String, dynamic> temp = await FirebaseComponents().getSpecificData(documentPath: 'users/${documentData['user_id']}', fields: ['username', 'image_urls']);
      documentData['username'] = temp['username'];
      documentData['profile'] = temp['image_urls'][0];
      fetchedData.add(documentData);
    }

    // Update _lastDocument after the loop
    if (snapshots.docs.isNotEmpty) {
      _lastDocument = snapshots.docs.last;
    }

    return fetchedData;
  }

}



class MusicTile extends StatefulWidget {
  final String title;
  final String artist;
  final String timestamp;
  final String imageUrl;
  final String audioUrl;
  final String? albumId;
  final String userID;
  final List<dynamic> tags;
  final Color barColor;
  final String uniqueID;

  MusicTile({
    required this.title,
    required this.artist,
    required this.timestamp,
    required this.imageUrl,
    required this.audioUrl,
    required this.albumId,
    required this.userID,
    required this.tags,
    required this.barColor,
    required this.uniqueID,
  });

  @override
  _MusicTileState createState() => _MusicTileState();
}

class _MusicTileState extends State<MusicTile> {
  final playNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    playNotifier.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: GlobalVariables.horizontalSpacing,
          vertical: 150,
        ),
        child: Container(
          width: GlobalVariables.properWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileText500(
                              text: widget.tags.map((tag) => tag.toString().toUpperCase()).join(', '),
                              size: 10,
                            ),
                            const SizedBox(height: GlobalVariables.smallSpacing),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: GlobalVariables.properWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (widget.albumId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlbumSongDisplayUploadView(albumID: widget.albumId!, userID: widget.userID),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleCoverDisplay(singleID: widget.uniqueID, userID: widget.userID),
                            ),
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileText600(text: widget.title, size: 30),
                          const SizedBox(height: GlobalVariables.smallSpacing - 15),
                          InformationText(text: widget.artist),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Profile(userID: widget.userID),
                            ),
                          );
                      },
                      child: 
                        ClipOval(
                          child: SizedBox(
                            width: 70.0,
                            height: 70.0,
                            child: FirstImageDisplay(documentPath: '/users/${widget.userID}'),
                          ),
                        ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: GlobalVariables.mediumSpacing),
              GestureDetector(
                onTap: () {
                  playNotifier.value = !playNotifier.value;
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(widget.imageUrl),
                ),
              ),
              const SizedBox(height: GlobalVariables.mediumSpacing),
              AudioPlayerUI(url: widget.audioUrl, playNotifier: playNotifier, barColor: widget.barColor),
              const SizedBox(height: GlobalVariables.mediumSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      playNotifier.value = !playNotifier.value;
                    },
                    child: ValueListenableBuilder(
                      valueListenable: playNotifier,
                      builder: (context, bool value, child) {
                        return Icon(value ? Icons.pause_circle : Icons.play_circle_fill_rounded, size: 30, color: Colors.grey);
                      },
                    ),
                  ),
                  Row(
                    children: [
                      LikeDislikeWidget(
                        type: widget.albumId != null ? "albums" : "singles", 
                        uniqueID: widget.uniqueID, 
                        userID: widget.userID, 
                        albumId: widget.albumId,
                        size: 25,sentence: 'liked your music'
                      ),
                      const SizedBox(width: 15),
                      CommentIcon(userID: widget.userID, uniqueID: widget.uniqueID, type: widget.albumId != null ? "albums" : "singles", size: 25, albumID: widget.albumId)
                    ],
                  ),
                ],
              ),
              const SizedBox(height: GlobalVariables.mediumSpacing),
              BioPreview(userID: widget.userID),
            ],
          ),
        ),
      ),
    );
  }
}


class MusicTileProvider extends ChangeNotifier {
  final Set<String> playingTracks = {};

  bool isPlaying(String uniqueID) {
    return playingTracks.contains(uniqueID);
  }

  void togglePlay(String uniqueID) {
    if (isPlaying(uniqueID)) {
      playingTracks.remove(uniqueID);
    } else {
      playingTracks.add(uniqueID);
    }
    notifyListeners();
  }
}

class AlbumListDisplay extends StatefulWidget {
  final String userID;
  final String collectionPath;
  final String title;
  final int? type;

  AlbumListDisplay({required this.userID, required this.collectionPath, required this.title, this.type});

  @override
  _AlbumListDisplayState createState() => _AlbumListDisplayState();
}

class _AlbumListDisplayState extends State<AlbumListDisplay> {
  List<Map<String, dynamic>> albums = [];

  @override
  void initState() {
    super.initState();
    FirebaseComponents().getCollectionData(collectionPath: widget.collectionPath).then((data) {
      setState(() {
        albums = data;
  
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileText400(text: widget.title, size: 12), // The text above the scroll
        const SizedBox(height: GlobalVariables.smallSpacing), // Optional: To give some spacing between the text and the horizontal scroll
        SizedBox(
          height: 150, // Adjusted the height to match the image size
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: albums.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (widget.type != 1) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => AlbumSongDisplayUploadView(userID: widget.userID, albumID: albums[index]['unique_id'])));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SingleCoverDisplay(userID: widget.userID, singleID: albums[index]['unique_id'])));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: GlobalVariables.smallSpacing),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0), // Adding corner edges
                      image: DecorationImage(
                        image: NetworkImage(albums[index]['image_urls'][widget.type ?? 0]),
                        fit: BoxFit.cover, // This will make the image fill the entire container
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ProfilePicture extends StatefulWidget {
  final double size;

  ProfilePicture({required this.size});

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    loadProfilePicture();
  }

  void loadProfilePicture() async {
    try {
      Map<String, dynamic> data = await FirebaseComponents().getSpecificData(
          documentPath: 'users/${GlobalVariables.userUUID}',
          fields: ['image_urls']);

      if (data['image_urls'] != null && data['image_urls'].length > 0) {
        setState(() {
          imageUrl = data['image_urls'][0];
        });
      }
    } catch (e) {
      print('Failed to load profile picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: imageUrl != null
          ? Image.network(
              imageUrl!,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.cover,
            )
          : Container(
              width: widget.size,
              height: widget.size,
              color: Colors.grey,
            ),  // Placeholder for when image is not loaded
    );
  }
}
class ProfileUsername extends StatefulWidget {
  final double size;

  ProfileUsername({required this.size});

  @override
  _ProfileUsernameState createState() => _ProfileUsernameState();
}

class _ProfileUsernameState extends State<ProfileUsername> {
  String? username;

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  void loadUsername() async {
    try {
      Map<String, dynamic> data = await FirebaseComponents().getSpecificData(
          documentPath: 'users/${GlobalVariables.userUUID}',
          fields: ['username']);

      if (data['username'] != null) {
        setState(() {
          username = data['username'];
        });
      }
    } catch (e) {
      print('Failed to load username: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return username != null
        ? ProfileText600(
            text: username!,
            size: widget.size,
          )
        : Container();  // Placeholder for when username is not loaded
  }
}


Future<void> likedFunction(String type, String uniqueID, String likedUser, String? albumID, String sentence) async {

  var path1 = "";
  var set2 = "";
  var path2 = "";

  if(albumID != null){
    path1 = 'users/$likedUser/$type/$albumID/collections/$uniqueID/likes/${GlobalVariables.userUUID}';
    set2 = 'users/$likedUser/$type/$albumID/collections/$uniqueID';
  } else {
    path1 = 'users/$likedUser/$type/$uniqueID/likes/${GlobalVariables.userUUID}';
    set2 = 'users/$likedUser/$type/$uniqueID';
  }
  
  if(type == "albums" || type == "singles"){

    path2 = 'users/${GlobalVariables.userUUID}/liked_songs/$uniqueID';
  } else {

    path2 = 'users/${GlobalVariables.userUUID}/liked_$type/$uniqueID';
  }

  String documentID = GlobalVariables().generateUUID().toString();
  Map<String, dynamic> data = await FirebaseComponents().getSpecialData(documentPath: 'users/${GlobalVariables.userUUID}');
  String username = data['username'];

  await Future.wait([
    FirebaseComponents.firebaseFirestore.doc(path1).set({
      'ref': '/users/${GlobalVariables.userUUID}'
    }),
    // placement of like under the media
    
    FirebaseComponents.firebaseFirestore.doc(path2).set({
      'ref': set2
    }),
      FirebaseComponents().setEachDataToFirestore('/users/${GlobalVariables.userUUID}/activity/$documentID', {'text': '$username $sentence', 'unique_id' : documentID})
  ]);
}

// This function is the opposite of likedFunction, it undoes a like action.
Future<bool> dislikedFunction(String type, String uniqueID, String likedUser, String? albumID) async {
  // Initialize paths
  var path1 = "";
  var path2 = "";

  // If albumID is not null, the media is part of an album, and paths are set accordingly.
  if(albumID != null){
    path1 = 'users/$likedUser/$type/$albumID/collections/$uniqueID/likes/${GlobalVariables.userUUID}';
  } 
  // If albumID is null, the media is not part of an album, and paths are set accordingly.
  else {
    path1 = 'users/$likedUser/$type/$uniqueID/likes/${GlobalVariables.userUUID}';
  }

  // Adjust path2 based on the type of media.
  if(type == "albums" || type == "singles"){
    path2 = 'users/${GlobalVariables.userUUID}/liked_songs/$uniqueID';
  } else {
    path2 = 'users/${GlobalVariables.userUUID}/liked_$type/$uniqueID';
  }

  // We use a try-catch to handle any potential exceptions from Firestore operations.
  try {
    await Future.wait([
      // The first operation deletes the document in Firestore at the path defined by 'path1'.
      FirebaseComponents.firebaseFirestore.doc(path1).delete(),
      // The second operation deletes the document in Firestore at the path defined by 'path2'.
      FirebaseComponents.firebaseFirestore.doc(path2).delete(),
    ]);
  } catch(e) {
    // If an exception is caught, print the error and return false.
    print('Error in dislikedFunction: $e');
    return false;
  }

  // If no exception is caught, print "done" and return true to indicate success.
  return true;
}

Future<bool> checkLikeExists(String type, String uniqueID, String likedUser, String? albumID) async {
  // Initialize paths
  var path1 = "";
  var path2 = "";

  // If albumID is not null, the media is part of an album, and paths are set accordingly.
  if(albumID != null){
    path1 = 'users/$likedUser/$type/$albumID/collections/$uniqueID/likes/${GlobalVariables.userUUID}';
  } 
  // If albumID is null, the media is not part of an album, and paths are set accordingly.
  else {
    path1 = 'users/$likedUser/$type/$uniqueID/likes/${GlobalVariables.userUUID}';
  }

  // Adjust path2 based on the type of media.
  if(type == "albums" || type == "singles"){
    path2 = 'users/${GlobalVariables.userUUID}/liked_songs/$uniqueID';
  } else {
    path2 = 'users/${GlobalVariables.userUUID}/liked_$type/$uniqueID';
  }

  // Retrieve documents from Firestore for both paths.
  var doc1 = FirebaseComponents.firebaseFirestore.doc(path1).get();
  var doc2 = FirebaseComponents.firebaseFirestore.doc(path2).get();

  // Await the results from both Firestore operations.
  var results = await Future.wait([doc1, doc2]);



  // Return true if both documents exist, false otherwise.
  return results[0].exists && results[1].exists;
}

class LikeDislikeWidget extends StatefulWidget {
  final String type;
  final String uniqueID;
  final String userID;
  final String? albumId;
  final double size;
  final String sentence;

  LikeDislikeWidget({required this.type, required this.uniqueID, required this.userID, required this.size, required this.sentence, this.albumId});

  @override
  _LikeDislikeWidgetState createState() => _LikeDislikeWidgetState();
}

class _LikeDislikeWidgetState extends State<LikeDislikeWidget> {
  late bool isLiked;

  Future<void> likeDislikeHandler() async {
    if (isLiked) {
      await dislikedFunction(widget.type, widget.uniqueID, widget.userID, widget.albumId);
    } else {
      await likedFunction(widget.type, widget.uniqueID, widget.userID, widget.albumId, widget.sentence);
    }
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLikeExists(widget.type, widget.uniqueID, widget.userID, widget.albumId), // this will fetch the albumId and then check if it exists
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasError)
            return Icon(Icons.error_outline, size: 30, color: Colors.red);
          else
            isLiked = snapshot.data ?? false; // If snapshot.data is null then default to false
            return GestureDetector(
              onTap: likeDislikeHandler,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: widget.size,
                color: Colors.grey,
              ),
            );
      },
    );
  }
}
