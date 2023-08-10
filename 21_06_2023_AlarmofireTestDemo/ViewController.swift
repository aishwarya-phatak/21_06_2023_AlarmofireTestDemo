//
//  ViewController.swift
//  21_06_2023_AlarmofireTestDemo
//
//  Created by Vishal Jagtap on 10/08/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    private let reuseIdetifierFoPostTableViewCell = "PostTableViewCell"
    
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
       initialization()
       registerWithXIB()
       fetchingData()
    }
    
    func registerWithXIB(){
        let uiNib = UINib(nibName: reuseIdetifierFoPostTableViewCell, bundle: nil)
        self.postTableView.register(uiNib, forCellReuseIdentifier: reuseIdetifierFoPostTableViewCell)
    }
    
    func initialization(){
        postTableView.dataSource = self
        postTableView.delegate = self
    }
    
    func fetchingData(){
       
        Alamofire.request("https://jsonplaceholder.typicode.com/posts").responseJSON { response in
            
            //print(response.result.value)
           let jsonResponse = response.result.value as! [[String:Any]]
            for eachPost in jsonResponse{
                let eachPost = eachPost
                let postId = eachPost["id"] as! Int
                let postTitle = eachPost["title"] as! String
                let postBody = eachPost["body"] as! String
                
                self.posts.append(Post(
                    id : postId,
                    title : postTitle,
                    body : postBody)
                )
            }
            
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
        }
    }
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postTableViewCell = self.postTableView.dequeueReusableCell(withIdentifier: reuseIdetifierFoPostTableViewCell, for: indexPath) as! PostTableViewCell
        
        postTableViewCell.postIdLabel.text = String(posts[indexPath.row].id)
        postTableViewCell.postTitleLabel.text = posts[indexPath.row].title
        postTableViewCell.postBodyLabel.text = posts[indexPath.row].body
        
        return postTableViewCell
    }
}


extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140.0
    }
}
