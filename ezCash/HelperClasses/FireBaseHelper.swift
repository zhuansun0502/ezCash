import Foundation
import Firebase
import CoreLocation
import MapKit

class FireBaseHelper: NSObject {
    
    let reference = Database.database().reference()
    let storageRef = Storage.storage().reference()
    
    func searchForUser(email: String, completion: @escaping(Bool) -> Void) {
        reference.child("Users").queryOrdered(byChild:  "Email").queryStarting(atValue: email).queryEnding(atValue: email).observeSingleEvent(of: .value, with: { (snapshot) in

            if !snapshot.exists() {
                completion(false)
            }
            else {
                completion(true)
            }
        })
    }
    
    func createNewUser(email: String, password: String, completion: @escaping(Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                completion(false)
                return
            }
            
            let userData = ["Email" : email, "userName" : "ez User", "phoneNum": ""]
            let user = self.reference.child("Users").child(Auth.auth().currentUser!.uid)
            
            user.updateChildValues(userData as [AnyHashable : Any], withCompletionBlock: {(err, ref) in
                if err != nil {
                    completion(false)
                    return
                }
                completion(true)
            })
        })
    }
    
    func login(email: String, password: String, completion: @escaping(Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
            if error != nil {
                completion(false)
                return
            }
            else {
                completion(true)
            }
        })
    }
    
    func uploadImage(uploadType: String, imageData: [Data], postID: String, completion: @escaping(Bool, String) -> Void) {
        let userID = Auth.auth().currentUser!.uid
        
        if uploadType == "pic_profile" {
            let user = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
            let imgRef = storageRef.child("Profile Pictures/\(userID).jpg")
                
            imgRef.putData(imageData[0], metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    completion(false, "")
                    print(error!)
                    return
                }
                
                imgRef.downloadURL(completion: {(imgURL, error) in
                    if error != nil {
                        print(error!)
                        completion(false, "")
                        return
                    }
                        
                    let userData = ["imageURL": imgURL?.absoluteString]
                    user.updateChildValues(userData as [AnyHashable : Any], withCompletionBlock: {(err, ref) in
                        if err != nil {
                            print(err!)
                            completion(false, "")
                            return
                        }
                        completion(true, imgURL!.absoluteString)
                    })
                })
            })
        }
        else {
            let user = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("Posts")
            let postImages = Database.database().reference().child("Posts").child(postID).child("images")
            
            var references = [StorageReference]()
            for i in 0..<imageData.count {
                let imageName = NSUUID().uuidString
                let imgRef = storageRef.child("Posts Pictures/\(userID)/\(postID)/\(imageName).jpg")
                references.append(imgRef)
                
                references[i].putData(imageData[i], metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        completion(false, "")
                        print(error!)
                        return
                    }
                    
                    references[i].downloadURL(completion: {(imgURL, error) in
                        if error != nil {
                            print(error!)
                            completion(false, "")
                            return
                        }
                            
                        let url = ["imageURL\(i)": imgURL?.absoluteString]
                        postImages.updateChildValues(url as [AnyHashable : Any], withCompletionBlock: {(err, ref) in
                            if err != nil {
                                print(err!)
                                completion(false, "")
                                return
                            }
                            completion(true, "")
                        })
                    })
                })
                
                let userData = ["\(postID)": ""]
                user.updateChildValues(userData as [AnyHashable : Any], withCompletionBlock: {(err, ref) in
                    if err != nil {
                        print(err!)
                        completion(false, "")
                        return
                    }
                })
            }
        }
    }
    
    func haveProfileImage(completion: @escaping(Bool) -> Void) {
        let user = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
        user.child("imageURL").observeSingleEvent(of: .value, with: { (snapshot) in

            if !snapshot.exists() {
                completion(false)
            }
            else {
                completion(true)
            }
        })
    }
    
    func getUserInfo(completion: @escaping(String, String, String, String) -> Void) {
        let user = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
        user.observe(.value, with: {(snapshot) in
                let userDict = snapshot.value as! [String:AnyObject]
                
                completion(userDict["Email"] as! String, userDict["imageURL"] as! String, userDict["userName"] as! String, userDict["phoneNum"] as! String)
        })
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
    }
    
    func updateUserInfo(userName: String, phoneNum: String, completion: @escaping(Bool) -> Void) {
        let user = Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid)
        
        let userData = ["userName": userName, "phoneNum": phoneNum]
        
        user.updateChildValues(userData as [AnyHashable : Any], withCompletionBlock: {(err, ref) in
            if err != nil {
                print(err!)
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    func isLoggedIn(completion: @escaping(Bool) -> Void) {
        if Auth.auth().currentUser?.uid == nil {
            completion(false)
        }
        else {
            completion(true)
        }
    }
    
    func createNewPost(postType: String, title: String, description: String, inReturnText: String, timeOwned: String, currentCondition: String, price: String, negotiable: Bool, deliver: Bool, postID: String, latitude: String, longitude: String, completion: @escaping(Bool) -> Void) {
        let userID = Auth.auth().currentUser!.uid
        let posts = Database.database().reference().child("Posts").child(postID)
        var postData = [String : Any]()
        
        if postType == "exchange" {
            postData = ["postType": postType, "title": title, "description": description, "inReturnText": inReturnText, "timeOwned": timeOwned, "currentCondition": currentCondition, "userID": userID, "latitude": latitude, "longitude": longitude]
        }
        else {
            postData = ["postType": postType, "title": title, "description": description, "price": price, "negotiable": String(negotiable), "deliver": String(deliver), "userID": userID, "latitude": latitude, "longitude": longitude]
        }
        
        posts.updateChildValues(postData as [AnyHashable : Any], withCompletionBlock: {(err, ref) in
            if err != nil {
                print(err!)
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    func getPostDetails(postID: String, completion: @escaping(String, String, String, String, String, String, String, String, String, String, String, [String]) -> Void) {
        let posts = Database.database().reference().child("Posts").child(postID)
        let postsPics = Database.database().reference().child("Posts").child(postID).child("images")
        
        var images = [String]()
        posts.observe(.value, with: {(snapshot) in
                let userDict0 = snapshot.value as! [String:Any]
            
                postsPics.observe(.value, with: {(snapshot) in
                    let userDict1 = snapshot.value as! [String:String]
                    
                    for image in Array(userDict1.values) {
                        images.append(image)
                    }
                    
                    if userDict0["postType"] as? String == "exchange" {
                        completion(userDict0["postType"] as! String, userDict0["title"] as! String, userDict0["description"] as! String, userDict0["inReturnText"] as! String, userDict0["timeOwned"] as! String, userDict0["currentCondition"] as! String, "", "", "", userDict0["latitude"] as! String, userDict0["longitude"] as! String, images)
                    }
                    else {
                        completion(userDict0["postType"] as! String, userDict0["title"] as! String, userDict0["description"] as! String, "", "", "", userDict0["price"] as! String, userDict0["negotiable"] as! String, userDict0["deliver"] as! String, userDict0["latitude"] as! String, userDict0["longitude"] as! String, images)
                    }
                })
        })
        
    }
}
