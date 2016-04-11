import UIKit
import CloudKit


class PostingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var postings: [CKRecord] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPostings()
    }
    
    @IBAction func refresh() {
        self.fetchPostings()
    }
    
    func fetchPostings() {
        // Build a query on the postings we want. We use a predicate to do this.
        let predicate = NSPredicate(value: true) // This predicate fetches everything. No filtering is applied.
        
        // Example of a more realistic predicate where we only want postings with the name "awesome"
//        let predicate = NSPredicate(format: "name == %@", "awesome") 
        
        let query = CKQuery(recordType: "Posting", predicate: predicate)
        
        // Fetch the records according to the query.
        let database = CKContainer.defaultContainer().publicCloudDatabase
        database.performQuery(query, inZoneWithID: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.postings = records!
        
            // Perform any UI operations on the main queue
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postings.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Posting", forIndexPath: indexPath) as! PostingCell
        
        let posting = self.postings[indexPath.row]
        
        // CKRecord are like dictionaries and follow same syntax.
        // The compiler doesn't know the types of the values, so you must cast them appropriately.
        cell.nameLabel.text = posting["name"] as? String
        cell.urlLabel.text = posting["url"] as? String
        
        return cell
    }
}