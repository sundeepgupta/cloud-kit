import UIKit
import CloudKit


class AddPostingVC: UIViewController {
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    
    @IBAction func save() {
        let container = CKContainer.defaultContainer()
        let database = container.publicCloudDatabase
        
        
        
        container.fetchUserRecordIDWithCompletionHandler { (userID, error) in
            if let e = error {
                print(e.localizedDescription)
                return
            }
            
            database.fetchRecordWithID(userID!, completionHandler: { (user, error) in
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                
                let owner = CKReference(record: user!, action: .DeleteSelf)
                
                let posting = CKRecord(recordType: "Posting")
                posting["url"] = self.urlField.text!
                posting["name"] = self.nameField.text!
                posting["owner"] = owner
                
                database.saveRecord(posting) { (record, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }

                
            })
            
        }
        
        
        
        
        
        
        
        
        
        
    }
}