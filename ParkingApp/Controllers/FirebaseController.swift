//
//  FirebaseController.swift
//  ParkingApp
//
//  Created by super on 2023-06-24.
//

import Foundation
import FirebaseFirestore

class FirestoreController : ObservableObject{
 
    @Published var parkList = [ParkingRecord]()
    @Published var userDetailsArray = [UserProfile]()
    
    private let db : Firestore
    private static var shared : FirestoreController?
    
    //collection and field names must match what you have on Firestore database
    
    private let COLLECTION_PARKINGS = "Parkings"
    private let COLLECTION_USERS = "Users"
    private let COLLECTION_USERSDETAILS = "UsersDetails"
    
    private let FIELD_BUILDINGCODE = "buildingCode"
    private let FIELD_HOURS = "hours"
    private let FIELD_PLATE = "plate"
    private let FIELD_SUIT = "suit"
    private let FIELD_ADDRESS = "address"
    private let FIELD_DATETIME = "datetime"
    

    private let FIELD_UPLATE = "plate"
    private let FIELD_UNAME = "name"
    private let FIELD_UEMAIL = "email"
    private let FIELD_UCONTACTNUM = "contactNum"
    
    private var loggedInUserEmail : String = ""
    
    init(db : Firestore){
        self.db = db
    }
    
    //singleton instance
    static func getInstance() -> FirestoreController{
        if (self.shared == nil){
            self.shared = FirestoreController(db: Firestore.firestore())
        }
        
        return self.shared!
    }
    
    func insertUser(newUser: UserProfile){
        
        print(#function, "Adding new user : \(newUser.name)")
        
        do{
            try self.db
                .collection(COLLECTION_USERS)
                .document(newUser.email)
                .collection(COLLECTION_USERSDETAILS)
                .addDocument(from: newUser)
            
            print(#function, "New User Record:  \(newUser.name), successfully added to database")
        }catch let err as NSError{
            print(#function, "Unable to add parking record to database : \(err)")
        }//do..catch
        
    }
    
    func insertParking(newPark : ParkingRecord){
        
        print(#function, "Inserting parking record : \(newPark.plate) - \(newPark.datetime)")
        
        //get the email address of currently logged in user
        self.loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
        
        if (self.loggedInUserEmail.isEmpty){
            print(#function, "Logged in user's email address not available. Can't add employee")
        }
        else{
            do{
                try self.db
                    .collection(COLLECTION_USERS)
                    .document(self.loggedInUserEmail)
                    .collection(COLLECTION_PARKINGS)
                    .addDocument(from: newPark)
                
                print(#function, "Parking Record:  \(newPark.plate) - \(newPark.datetime), successfully added to database")
            }catch let err as NSError{
                print(#function, "Unable to add parking record to database : \(err)")
            }//do..catch
        }//else
        
    }
    
    func getUserDetails(){
        print(#function, "Trying to get user details.")
        
        //get the email address of currently logged in user
        self.loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
        
        
        if (self.loggedInUserEmail.isEmpty){
            print(#function, "Logged in user's email address not available. Can't show details.")
        }else{
            do{
                self.db
                    .collection(COLLECTION_USERS)
                    .document(self.loggedInUserEmail)
                    .collection(COLLECTION_USERSDETAILS)
                    .addSnapshotListener({ (querySnapshot, error) in
                        
                        guard let snapshot = querySnapshot else{
                            print(#function, "Unable to retrieve data from database : \(error)")
                            return
                        }
                        
                        snapshot.documentChanges.forEach{ (docChange) in
                            
                            do{
                                //convert JSON document to swift object
                                var userDetails : UserProfile = try docChange.document.data(as: UserProfile.self)
                                
                                //get the document id so that it can be used for updating and deleting document
                                var documentID = docChange.document.documentID
                                
                                //set the firestore document id to the converted object
                                userDetails.id = documentID
                                
                                print(#function, "Document ID : \(documentID)\n \(userDetails.email)")
                                
                                //if new document added, perform required operations
                                if docChange.type == .added{
                                    self.userDetailsArray.append(userDetails)
                                    print(#function, "User details document added.")
                                }
                                
                                //get the index of any matching object in the local list for the firestore document that has been deleted or updated
                                let matchedIndex = self.userDetailsArray.firstIndex(where: { ($0.id?.elementsEqual(documentID))! })
                                
//                                //if a document deleted, perform required operations
//                                if docChange.type == .removed{
//                                    print(#function, " Document removed : \(park.plate) - \(park.datetime)")
//
//                                    //remove the object for deleted document from local list
//                                    if (matchedIndex != nil){
//                                        self.parkList.remove(at: matchedIndex!)
//                                    }
//                                }
//
//                                //if a document updated, perform required operations
//                                if docChange.type == .modified{
//                                    print(#function, " Document updated : \(park.plate) - \(park.datetime)")
//
//                                    //update the existing object in local list for updated document
//                                    if (matchedIndex != nil){
//                                        self.parkList[matchedIndex!] = park
//                                    }
//                                }
//
                            }catch let err as NSError{
                                print(#function, "Unable to convert the JSON doc into Swift Object : \(err)")
                            }
                            
                        }//ForEach
                        
                    })//addSnapshotListener
                
            }catch let err as NSError{
                print(#function, "Unable to get all parking records from database : \(err)")
            }//do..catch
//            do{
//
//                self.db
//                    .collection(COLLECTION_USERS)
//                    .document(self.loggedInUserEmail)
//                    .collection(COLLECTION_USER_DETAILS)
//                    .whereField("email", isEqualTo: self.loggedInUserEmail)
//                    .getDocuments(completion: { querySnapshot, error in
//                        if let error = error {
//                            // Handle the error
//                            print("Error fetching user details: \(error)")
//                            return
//                        }
//                        guard let documents = querySnapshot?.documents else {
//                            // Handle the case when no documents are found
//                            print("No user details found")
//                            return
//                        }
//
//                        if let doc = documents.first {
//                            do{
//                                var userData:UserProfile = try doc.data(as: UserProfile.self)
//                                self.userDetails = userData
//                            }catch let err as NSError{
//                                print(#function, "Unable to convert the JSON doc into Swift Object : \(err)")
//                            }
//                        }
//
//                    })
//
//            }catch let err as NSError{
//                print(#function, "Unable to get all parking records from database : \(err)")
//            }//do..catch
        }//else
    }
    
    func getAllParking(){
        print(#function, "Trying to get all parking records.")
        
        
        //get the email address of currently logged in user
        self.loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
        
        
        if (self.loggedInUserEmail.isEmpty){
            print(#function, "Logged in user's email address not available. Can't show employees")
        }
        else{
            do{
                
                self.db
                    .collection(COLLECTION_USERS)
                    .document(self.loggedInUserEmail)
                    .collection(COLLECTION_PARKINGS)
                    .addSnapshotListener({ (querySnapshot, error) in
                        
                        guard let snapshot = querySnapshot else{
                            print(#function, "Unable to retrieve data from database : \(error)")
                            return
                        }
                        
                        snapshot.documentChanges.forEach{ (docChange) in
                            
                            do{
                                //convert JSON document to swift object
                                var park : ParkingRecord = try docChange.document.data(as: ParkingRecord.self)
                                
                                //get the document id so that it can be used for updating and deleting document
                                var documentID = docChange.document.documentID
                                
                                //set the firestore document id to the converted object
                                park.id = documentID
                                
                                print(#function, "Document ID : \(documentID)")
                                
                                //if new document added, perform required operations
                                if docChange.type == .added{
                                    self.parkList.append(park)
                                    print(#function, "New document added : \(park.plate) - \(park.datetime)")
                                }
                                
                                //get the index of any matching object in the local list for the firestore document that has been deleted or updated
                                let matchedIndex = self.parkList.firstIndex(where: { ($0.id?.elementsEqual(documentID))! })
                                
                                //if a document deleted, perform required operations
                                if docChange.type == .removed{
                                    print(#function, " Document removed : \(park.plate) - \(park.datetime)")
                                    
                                    //remove the object for deleted document from local list
                                    if (matchedIndex != nil){
                                        self.parkList.remove(at: matchedIndex!)
                                    }
                                }
                                
                                //if a document updated, perform required operations
                                if docChange.type == .modified{
                                    print(#function, " Document updated : \(park.plate) - \(park.datetime)")
                                    
                                    //update the existing object in local list for updated document
                                    if (matchedIndex != nil){
                                        self.parkList[matchedIndex!] = park
                                    }
                                }
                                
                            }catch let err as NSError{
                                print(#function, "Unable to convert the JSON doc into Swift Object : \(err)")
                            }
                            
                        }//ForEach
                        
                    })//addSnapshotListener
                
            }catch let err as NSError{
                print(#function, "Unable to get all parking records from database : \(err)")
            }//do..catch
        }//else
    }
    
    func deleteUserData(){
        print(#function, "Deleting user data")
        
        //get the email address of currently logged in user
        self.loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
        
        if (self.loggedInUserEmail.isEmpty){
            print(#function, "Logged in user's email address not available. Can't delete employees")
        }else{
            // Get a reference to the user document
            let userDocumentRef = self.db.collection(COLLECTION_USERS).document(self.loggedInUserEmail)
            
            // Delete the subcollections of the user document
            self.deleteSubcollection(userDocumentRef,collectionName: self.COLLECTION_PARKINGS) { success in
                if (success != nil) {
                    // Delete the main user document
//                    self.deleteUserDocument(userDocumentRef)
                    print(#function, "Success: deleted subcollection \(self.COLLECTION_PARKINGS)")
                } else {
                    print(#function, "Failed to delete subcollection \(self.COLLECTION_PARKINGS)")
                }
            }
            self.deleteSubcollection(userDocumentRef,collectionName: self.COLLECTION_USERSDETAILS) { success in
                if (success != nil) {
                    // Delete the main user document
                    print(#function, "Success: deleted subcollection \(self.COLLECTION_USERSDETAILS)")
                    self.deleteUserDocument(userDocumentRef)
                    print(#function, "Success: deleted user document")
                } else {
                    print(#function, "Failed to delete subcollection \(self.COLLECTION_USERSDETAILS)")
                }
            }
            
            
//            do{
//                try self.db
//                    .collection(COLLECTION_USERS)
//                    .document(self.loggedInUserEmail)
//                    .delete{ error in
//                        if let err = error {
//                            print(#function, "Unable to delete user data from database : \(err)")
//                        }else{
//                            print(#function, "User data for \(self.loggedInUserEmail), successfully deleted from database")
//                        }
//                    }
//            }catch let err as NSError{
//                print(#function, "Unable to delete parking record from database : \(err)")
//            }
        }
    }
    
    private func deleteSubcollection(_ documentRef: DocumentReference, collectionName: String, batchSize: Int = 100, completion: @escaping (Error?) -> Void) {
        let collectionRef = documentRef.collection(collectionName)
        
        // Limit the batch size for document fetch and deletion
        var batchCount = 0
        
        // Fetch and delete documents in batches
        collectionRef.limit(to: batchSize).getDocuments { (querySnapshot, error) in
            // Check for errors
            if let error = error {
                completion(error)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                // Collection is already empty, delete the collection
                collectionRef.document().delete(completion: completion)
                return
            }
            
            // Create a new batch
            let batch = collectionRef.firestore.batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
                batchCount += 1
            }
            
            // Commit the batch
            batch.commit { (error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                // Recursively delete the next batch if more documents exist
                if batchCount >= batchSize {
                    self.deleteSubcollection(documentRef, collectionName: collectionName, batchSize: batchSize, completion: completion)
                } else {
                    // All documents deleted, delete the collection itself
                    collectionRef.document().delete(completion: completion)
                }
            }
        }
        
    }

    
    private func deleteUserDocument(_ documentRef: DocumentReference) {
        // Delete the main document
        documentRef.delete { error in
            if let error = error {
                print(#function, "Unable to delete user data from database: \(error.localizedDescription)")
            } else {
                print(#function, "User data for \(self.loggedInUserEmail) successfully deleted from database")
            }
        }
    }
    
    func deleteParking(parkToDel : ParkingRecord){
        print(#function, "Deleting parking record \(parkToDel.plate) - \(parkToDel.datetime))")
        
        
        //get the email address of currently logged in user
        self.loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
        
        if (self.loggedInUserEmail.isEmpty){
            print(#function, "Logged in user's email address not available. Can't delete employees")
        }
        else{
            do{
                try self.db
                    .collection(COLLECTION_USERS)
                    .document(self.loggedInUserEmail)
                    .collection(COLLECTION_PARKINGS)
                    .document(parkToDel.id!)
                    .delete{ error in
                        if let err = error {
                            print(#function, "Unable to delete parking record from database : \(err)")
                        }else{
                            print(#function, "Parking Record \(parkToDel.plate) - \(parkToDel.datetime), successfully deleted from database")
                        }
                    }
            }catch let err as NSError{
                print(#function, "Unable to delete parking record from database : \(err)")
            }
        }
    }
    
    func updateUserDetails(userToUpdate : UserProfile){
        print(#function, "Updating user record \(userToUpdate.name).")
        
        
        //get the email address of currently logged in user
        self.loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
        
        if (self.loggedInUserEmail.isEmpty){
            print(#function, "Logged in user's email address not available. Can't update")
        }else{
            do{
                try self.db
                    .collection(COLLECTION_USERS)
                    .document(self.loggedInUserEmail)
                    .collection(COLLECTION_USERSDETAILS)
                    .document(userToUpdate.id!)
                    .updateData([FIELD_UCONTACTNUM : userToUpdate.contactNum,
                                        FIELD_UEMAIL : userToUpdate.email,
                                        FIELD_UPLATE : userToUpdate.plate,
                                         FIELD_UNAME : userToUpdate.name]){ error in
                        
                        if let err = error {
                            print(#function, "Unable to update user details in database : \(err)")
                        }else{
                            print(#function, "User details \(userToUpdate.name), successfully updated in database")
                        }
                    }
            }catch let err as NSError{
                print(#function, "Unable to update user details in database : \(err)")
            }
        }
    }
    
    func updatePark(parkToUpdate : ParkingRecord){
        print(#function, "Updating parking record \(parkToUpdate.plate) - \(parkToUpdate.datetime).")
        
        
        //get the email address of currently logged in user
        self.loggedInUserEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
        
        if (self.loggedInUserEmail.isEmpty){
            print(#function, "Logged in user's email address not available. Can't update")
        }
        else{
            do{
                try self.db
                    .collection(COLLECTION_USERS)
                    .document(self.loggedInUserEmail)
                    .collection(COLLECTION_PARKINGS)
                    .document(parkToUpdate.id!)
                    .updateData([FIELD_BUILDINGCODE : parkToUpdate.buildingCode,
                                        FIELD_HOURS : parkToUpdate.hours,
                                        FIELD_PLATE : parkToUpdate.plate,
                                         FIELD_SUIT : parkToUpdate.suit,
                                      FIELD_ADDRESS : parkToUpdate.address,
                                     FIELD_DATETIME : parkToUpdate.datetime]){ error in
                        
                        if let err = error {
                            print(#function, "Unable to update parking record in database : \(err)")
                        }else{
                            print(#function, "Parking record \(parkToUpdate.plate) - \(parkToUpdate.datetime), successfully updated in database")
                        }
                    }
            }catch let err as NSError{
                print(#function, "Unable to update parking record in database : \(err)")
            }
        }
    }
    
    
    
}
