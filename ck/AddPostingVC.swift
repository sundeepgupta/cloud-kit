import UIKit
import CloudKit


class AddPostingVC: UIViewController {
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    
    @IBAction func save() {
        // Here we'll create a Posting and associate to the user
        let posting = CKRecord(recordType: "Posting")
        posting["url"] = self.urlField.text!
        posting["name"] = self.nameField.text!

        
        // The User is associated with the Container, not a Database
        let container = CKContainer.defaultContainer()
        container.fetchUserRecordIDWithCompletionHandler { (userID, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            // To associate the posting to the user, create a CKReference 
            // Remember, associate "up". Meaning, specify what an object's parent is.
            // Like Core Data relationships, you must also define what happens if the parent is deleted.
            let parent = CKReference(recordID: userID!, action: .DeleteSelf)
            posting["parent"] = parent
            
            // Saving the posting to the CloudKit database
            let database = container.publicCloudDatabase
            database.saveRecord(posting) { (record, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
               
                // UI operation - do on main queue
                dispatch_async(dispatch_get_main_queue(), {
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            }
        }
    }
}