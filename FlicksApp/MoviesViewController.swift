//
//  MoviesViewController.swift
//  FlicksApp
//
//  Created by dinesh on 31/01/17.
//  Copyright © 2017 dinesh. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
   
  
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var CollectView: UICollectionView!
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CollectView.dataSource = self
        searchBar.delegate = self
        //CollectView.delegate = self
            //tableView.dataSource = self
            //tableView.delegate = self
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        CollectView.insertSubview(refreshControl, at: 0)
        
        MBProgressHUD.showAdded(to: self.view, animated: true)

        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    self.filteredData = self.movies
                    //self.tableView.reloadData()
                    self.CollectView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
        task.resume()
        
        
        
        
        
        
    }
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    self.filteredData = self.movies
                    //self.tableView.reloadData()
                    self.CollectView.reloadData()
                    //MBProgressHUD.hide(for: self.view, animated: true)
                    refreshControl.endRefreshing()
                }
            }
        }
        task.resume()
        
        
        
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if let filteredData = filteredData {
            return filteredData.count
        }
        else{
            return 0
        }
        
    
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        var movie_name = filteredData?[indexPath.row]["title"] as! String
        var movie_overview = filteredData?[indexPath.row]["overview"] as! String
        
        var poster_path = filteredData?[indexPath.row]["poster_path"] as! String
        poster_path = "https://image.tmdb.org/t/p/w342" + poster_path
        
        let cell = CollectView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionCell", for: indexPath) as! MovieCollectionCell
        //let img_url = URL(string: poster_path)
        let imageRequest = NSURLRequest(url: NSURL(string: poster_path)! as URL)
        //cell.movieImage.setImageWith(img_url!)
        cell.movieImage.setImageWith(
            imageRequest as URLRequest,
            placeholderImage: nil,
            success: { (imageRequest, imageResponse, image) -> Void in
                
                // imageResponse will be nil if the image is cached
                if imageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.movieImage.alpha = 0.0
                    cell.movieImage.image = image
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.movieImage.alpha = 1.0
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.movieImage.image = image
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        return cell
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        var temp: [NSDictionary] = []
        if(searchText.isEmpty){
            self.filteredData = self.movies
        }
        else{
            for movie in movies!{
                //print ("first succ \(movie)")
                let title = movie["title"] as! String
                if title.lowercased().range(of: searchText.lowercased()) != nil{
                    print ("\(movie)")
                    temp.append(movie)
                }
            }
            self.filteredData = temp
        }
        self.CollectView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var movie_name = movies?[indexPath.row]["title"] as! String
        var movie_overview = movies?[indexPath.row]["overview"] as! String
        
        var poster_path = movies?[indexPath.row]["poster_path"] as! String
        poster_path = "https://image.tmdb.org/t/p/w342" + poster_path
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for : indexPath)
        //cell = "\(movie_name)"
        /*cell.movieLabel.text = "\(movie_name)"
        cell.movieOverview.text = "\(movie_overview)"
        cell.movieOverview.numberOfLines = 0
        let img_url = URL(string: poster_path)
        cell.movieImage.setImageWith(img_url!)
        print ("\(poster_path)")
        cell.movieImage.clipsToBounds = true
        cell.movieImage.layer.cornerRadius = 12*/
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
