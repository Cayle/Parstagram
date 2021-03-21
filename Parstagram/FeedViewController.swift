//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Caleb Abhulimhen on 3/19/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var posts =  [PFObject]()
    
    @IBOutlet weak var tableView: UITableView!
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPictures()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        myRefreshControl.addTarget(self, action: #selector(loadPictures), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
      
    @objc func loadPictures() {
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
        if posts != nil {
            self.posts = posts!
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        } else {
            print("Error occured \(String(describing: error))")
            }
        }
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let query = PFQuery(className: "Posts")
//        query.includeKey("author")
//        query.limit = 20
//
//        query.findObjectsInBackground { (posts, error) in
//            if posts != nil {
//                self.posts = posts!
//                self.tableView.reloadData()
//            } else {
//                print("Error occured \(String(describing: error))")
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let length = posts.count
        let post = posts[length - 1 - indexPath.row]
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        cell.captionLabel.text = (post["caption"] as! String)
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af.setImage(withURL: url)
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
