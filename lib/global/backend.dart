import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseBackend {

  Future<void> addDocumentToFirestore(String collectionPath, Map<String, dynamic> data) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(collectionPath);

    try {
      await collection.add(data);
      print("Document added successfully.");
    } catch (e) {
      print("Error adding document: $e");
    }
  }

  Future<void> addDocumentToFirestoreWithId(String collectionPath, String documentId, Map<String, dynamic> data) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection(collectionPath).doc(documentId);

    try {
      await documentReference.set(data);
      print("Document with ID $documentId added successfully.");
    } catch (e) {
      print("Error adding document: $e");
    }
  }

  Future<void> updateDocumentInFirestore(String collectionPath, String documentId, Map<String, dynamic> data) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection(collectionPath).doc(documentId);

    try {
      await documentReference.update(data);
      print("Document with ID $documentId updated successfully.");
    } catch (e) {
      print("Error updating document: $e");
    }
  }


  Future<void> deleteDocumentFromFirestore(String collectionPath, String documentId) async {
    DocumentReference documentReference =  FirebaseFirestore.instance.collection(collectionPath).doc(documentId);

    try {
      await documentReference.delete();
      print("Document with ID $documentId deleted successfully.");
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  Future<void> deleteFieldsFromDocument(String collectionPath, String documentId, List<String> fields) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection(collectionPath).doc(documentId);

    Map<String, dynamic> updates = {};
    for (String field in fields) {
      updates[field] = FieldValue.delete();
    }

    try {
      await documentReference.update(updates);
      print("Fields deleted successfully from document ID $documentId.");
    } catch (e) {
      print("Error deleting fields: $e");
    }
  }

  Future<void> deleteCollection(String collectionPath, int batchSize) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(collectionPath);
    QuerySnapshot querySnapshot;
    List<DocumentSnapshot> toDelete;

    do {
      querySnapshot = await collection.limit(batchSize).get();
      toDelete = querySnapshot.docs;

      for (DocumentSnapshot doc in toDelete) {
        await doc.reference.delete();
      }
    } while (toDelete.isNotEmpty);
  }

  Future<List<Map<String, dynamic>>> getAllDocuments(String collectionPath) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(collectionPath);
    QuerySnapshot querySnapshot = await collection.get();

    List<Map<String, dynamic>> documents = [];
    for (var doc in querySnapshot.docs) {
      documents.add(doc.data() as Map<String, dynamic>);
    }

    return documents;
  }

  Future<Map<String, dynamic>> getSpecificFieldsFromDocument(String collectionPath, String documentId, List<String> fields) async {
    DocumentReference docRef = FirebaseFirestore.instance.collection(collectionPath).doc(documentId);
    DocumentSnapshot docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      print('Document does not exist!');
      return {};
    }

    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    Map<String, dynamic> specificData = {};
    for (String field in fields) {
      if (data.containsKey(field)) {
        specificData[field] = data[field];
      }
    }

    return specificData;
  }

  Future<Map<String, dynamic>> getDocumentData(String collectionPath, String documentId) async {
    DocumentReference docRef = FirebaseFirestore.instance.collection(collectionPath).doc(documentId);
    DocumentSnapshot docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      print('Document does not exist!');
      return {};
    }

    return docSnapshot.data() as Map<String, dynamic>;
  }

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
  Future<List<String>> uploadFiles(List<File> imageFiles, String storagePath) async {
    List<String> downloadUrls = [];

    for (File imageFile in imageFiles) {
      try {
        String fileName = const Uuid().v4();; // Generate a unique file name for each file
        Reference storageReference = FirebaseStorage.instance.ref().child('$storagePath/$fileName');
        UploadTask uploadTask = storageReference.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } catch (e) {
        print(e);
        // Optionally, handle the error for each file upload
      }
    }

    return downloadUrls;
  }
}