//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Josh Gebbeken on 1/7/16.
//  Copyright © 2016 Josh Gebbeken. All rights reserved.
//

import UIKit
import AFNetworking // adds in image url support
import EZLoadingActivity
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var movies: [NSDictionary] = []
    var filteredMovies: [NSDictionary] = []
    var refreshControl: UIRefreshControl!
    var filteredText: [String]!
    let noNetworklabel = UILabel(frame: CGRectMake(0, 0, 320, 50))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    
        
        
        // No network warning label
        
        noNetworklabel.textAlignment = NSTextAlignment.Center
        noNetworklabel.text = "No Network."
        noNetworklabel.backgroundColor = UIColor.orangeColor()
        tableView.insertSubview(noNetworklabel, atIndex: 1)
        noNetworklabel.hidden = true
        
        
        // Refresh controls added to table view
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        

       // Do any additional setup after loading the view.
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        // Start loading state HUD
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.filteredMovies = responseDictionary["results"] as! [NSDictionary]
                        
                            
                            // End loading state HUD
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                            // Reload table data
                            self.tableView.reloadData()

                            print("loading complete")
                    }
                }
        });
        task.resume()
        
    }
    
    
    // onRefresh Methods
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        
        
        
        delay(4, closure: {
            
            self.refreshControl.endRefreshing()
            
        })
        
    
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return filteredMovies.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        let movie = filteredMovies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        if let posterPath = movie["poster_path"] as? String {
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        let request = NSURLRequest(URL: imageUrl!)
        let placeholderImage = UIImage(named: "MovieHolder")
        
        
        // Older non - fade in code
        //cell.posterView.setImageWithURL(imageUrl!)
    
        cell.posterView.alpha = 0
        
        // Get poster image and set animation options.
        cell.posterView.setImageWithURLRequest(request, placeholderImage: placeholderImage, success: { (request, response, imageData) -> Void in
            UIView.transitionWithView(cell.posterView, duration: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { cell.posterView.image = imageData; cell.posterView.alpha = 2.0 }, completion: nil   );
            
            // If response was nil due to image being already cached then do this instead
            if response == nil {
                // Fade out images
                UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations:{ cell.posterView.alpha = 0}, completion: nil)
                
                // Fade in cached images
                UIView.animateWithDuration(1.0, delay: 2.0, options: UIViewAnimationOptions.CurveEaseIn, animations:{ cell.posterView.alpha = 1}, completion: nil) }
            }, failure: nil)
        }
            
        // For posters who don't have a poster view yet.
        else
        {
            cell.posterView.image = UIImage(named: "Rgvbn3m.jpg")
            
        }
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview

        return cell
        
        
    }
    
    func searchBar(searchBar : UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies.filter({ (movie: NSDictionary) -> Bool in
            let title = movie["title"] as! String
            return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        tableView.reloadData()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
