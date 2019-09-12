//
//  ViewController.swift
//  Task
//
//  Created by Dinesh on 11/09/19.
//  Copyright © 2019 task. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let postsCell = "PostsCell"
    
    let refreshControl = UIRefreshControl()
    
    var postResponseResult = [PostResponseResult]()
    
    var postResponseResultSelected = [PostResponseResult]()

    
    var page = 1
    
    lazy var postsTV:UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.allowsSelection = true
        table.backgroundColor = .clear
        table.isScrollEnabled = true
        table.delegate = self
        table.dataSource = self
        refreshControl.addTarget(self, action: #selector(postsRefreshAction), for: .valueChanged)
        table.refreshControl = refreshControl
        return table
    }()
    
    lazy var countLBL: UILabel = {
        let lb = UILabel()
        lb.text = "0"
        lb.font = UIFont.boldSystemFont(ofSize: 16.0)
        lb.backgroundColor = .clear
        lb.textColor = .white
        lb.numberOfLines = 0
        return lb
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(postsTV)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: countLBL)

        
        postsTV.setAnchor(top: view.safeTopAnchor, left: view.safeLeftAnchor , bottom: view.safeBottomAnchor  , right: view.safeRightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        let url = ApiInterface.getPostsData+String(page)
        
        ApiService.callPost(url:url, params:"" ,methodType:"GET",tag: "getPosts" ,finish: finishPost)

        
        registerCells()
        
    }
    
    fileprivate func registerCells() {
        
        postsTV.estimatedRowHeight = 75
        postsTV.rowHeight = UITableView.automaticDimension
        postsTV.register(PostsCell.self, forCellReuseIdentifier: postsCell)
        
    }
    
    func finishPost (message:String, data:Data? , tag: String) -> Void
    {
        do
        {
            if let jsonData = data
            {
                
                if tag == "getPosts" {
                    
                    refreshControl.endRefreshing()
                    
                    let parsedData = try JSONDecoder().decode(PostsResponse.self, from: jsonData)
                    print(parsedData)
                    
                    postResponseResult.append(contentsOf:parsedData.hits)

                    
                    if postResponseResult.count > 0{
                        
                        
                        postsTV.reloadData()
                    
                    }
                }
            }
            
        }
        catch
        {
        
            print("Parse Error: \(error)")
            
        }
    }
    
    @objc func postsRefreshAction(){
        
        page = 1
        
        postResponseResult.removeAll()
        
        let url = ApiInterface.getPostsData+String(page)

        ApiService.callPost(url:url, params:"" ,methodType:"GET",tag: "getPosts" ,finish: finishPost)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postResponseResult.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = postsTV.dequeueReusableCell(withIdentifier: postsCell, for: indexPath) as! PostsCell
        
        let index = postResponseResult[indexPath.row]

        cell.postResponseResult = index
        
        
        if postResponseResultSelected.contains(where: { $0.created_at == index.created_at }) {
            
            cell.toggleSW.setOn(true, animated: true)

        }else {
            
            cell.toggleSW.setOn(false, animated: true)

            
        }
        
        if indexPath.row == postResponseResult.count-1 {
            
            lodeMoreData()
            
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = postResponseResult[indexPath.row]

        if let index = postResponseResultSelected.firstIndex(where: { $0.created_at == index.created_at }) {
            
            postResponseResultSelected.remove(at: index)
            
        }else {
            
            postResponseResultSelected.append(index)

            
        }
        
        postsTV.reloadData()
        
        countLBL.text = String(postResponseResultSelected.count)
        
    }

    func lodeMoreData(){

        page = page+1
        
        let url = ApiInterface.getPostsData+String(page)
        
        ApiService.callPost(url:url, params:"" ,methodType:"GET",tag: "getPosts" ,finish: finishPost)

        
    }

}

