// This class is a single instance class that other files can access it's variables and functions
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ndy/Backend/StructureComponents.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:ndy/Backend/FirebaseComponents.dart';

import '../FrontEndComponents/TextComponents.dart';
import 'GlobalComponents.dart';

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
        print("error");
        return null;
      }
    } catch (e) {
      //failure in try / catch
      print(e);
      return null;
    }
  }

  // Get data 
  Future<Map<String, dynamic>> getSpecificData(
      {required String documentPath, required List<String> fields}) async {
    // Get a DocumentReference
    DocumentReference docRef = firebaseFirestore.doc(documentPath);

    // Get the document
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Get the document data
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      // Filter the data to only include the required fields
      Map<String, dynamic> filteredData = {};
      for (String field in fields) {
        if (data.containsKey(field)) {
          print(data[field]);
          filteredData[field] = data[field];
        }
      }

      return filteredData;
    } else {
      throw Exception('Document does not exist');
    }
  }

    Future<List<Map<String, dynamic>>> getCollectionData(
      {required String collectionPath, required List<String> fields}) async {
    // Get a CollectionReference
    CollectionReference colRef = firebaseFirestore.collection(collectionPath);

    // Get the documents in the collection
    QuerySnapshot querySnapshot = await colRef.get();

    // Get the data for each document in the collection
    List<Map<String, dynamic>> allData = [];
    for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      // Filter the data to only include the required fields
      Map<String, dynamic> filteredData = {};
      for (String field in fields) {
        if (data.containsKey(field)) {
          print(data[field]);
          filteredData[field] = data[field];
        }
      }

      allData.add(filteredData);
    }

    return allData;
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

    data['timestamp'] = timeStampData;
    
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

  Future<bool> addDocumentWithTags(String documentID, String documentPath, String tagType, List<String> tags) async {
    // Get a reference to the Firestore instance
    final firestore = firebaseFirestore;

    
    // Add a reference to the document in each tag collection
    for (String tag in tags) {
      await firestore.doc('$tagType/$tag').set({"placeholder" : "null"});
      await firestore.collection('$tagType/$tag/collection').doc(documentID).set({
        'ref': firestore.collection(documentPath).doc(documentID),
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
    });

    return true;
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
            print('Image upload complete.');

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
        'image_urls': downloadURLs,
      });

      print('Image URLs stored in Firestore.');

      return true;
    } catch (e) {
      print("Breh");
      print(e);
      return false;
    }
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Text('No images found.');
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
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Text('No images found.');
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
      fields: this.fields,
    );
  }

  Widget displayData() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getCollectionData(),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> docData = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.only(
                  left: GlobalVariables.horizontalSpacing,
                  right: GlobalVariables.horizontalSpacing,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2.0),
                      child: Image.network(
                        docData['image_urls'][0],
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GenericTextSemi(text: docData['title']),
                        const SizedBox(height: GlobalVariables.smallSpacing - 5),
                        GenericTextReg(text: docData['artists']),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}



