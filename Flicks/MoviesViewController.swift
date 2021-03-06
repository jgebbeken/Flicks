//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Josh Gebbeken on 1/7/16.
//  Copyright © 2016 Josh Gebbeken. All rights reserved.
//
//
//   Icons created by Berkay Sargin and Daaouna Jeong from the
//   Noun Project

import UIKit
import AFNetworking // adds in image url support
import EZLoadingActivity
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var noNetwork: UIView!
    @IBOutlet weak var btnCloseNoNetworkView: UIButton!
    @IBOutlet weak var noNetworkLabel: UILabel!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies: [NSDictionary] = []
    var filteredMovies: [NSDictionary] = []
    var refreshControl: UIRefreshControl!
    var filteredText: [String]!
    
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
    

        // No Network UIView and controls
        noNetwork.hidden = true
        view.bringSubviewToFront(noNetwork)
        btnCloseNoNetworkView.addTarget(self, action: "networkErrorRefresh:", forControlEvents: UIControlEvents.TouchUpInside)
  
        
        // Refresh controls added to table view
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView.insertSubview(refreshControl, atIndex: 0)
        
        if endpoint == "now_playing"
        {
            self.navigationItem.title = "Now Playing"
        }
        else
        {
            self.navigationItem.title = "Top Rated"
        }
        
        
        // Load Movie Data
        getMovieData()
        
    }
    
    func getMovieData () -> () {
       // Do any additional setup after loading the view.
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        // Start loading state HUD
        let spinning = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinning.labelText = "Loading"
        spinning.detailsLabelText = "Movie Data"
        
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
                            self.collectionView.reloadData()

                            print("loading complete")
                    }
                }
                if error != nil {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.showNetworkError()
                }
        });
        task.resume()
        
    }
    
    
    func showNetworkError () -> () {

        searchBar.hidden = true
        noNetwork.hidden = false
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = filteredMovies[indexPath.row]
        
        if let posterPath = movie["poster_path"] as? String {
            let baseUrl = "http://image.tmdb.org/t/p/w500"
            
            let imageUrl = NSURL(string: baseUrl + posterPath)
            
            let request = NSURLRequest(URL: imageUrl!)
            let placeholderImage = UIImage(named: "MovieHolder")
            
            
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
        
        return cell
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredMovies.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        cell.contentView.backgroundColor = UIColor.orangeColor()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        cell.contentView.backgroundColor = UIColor.clearColor()
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
    
    
    func searchBar(searchBar : UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies.filter({ (movie: NSDictionary) -> Bool in
            let title = movie["title"] as! String
            return title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        collectionView.reloadData()
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        getMovieData()
        
    }
    

    
    func networkErrorRefresh(sender: UIButton!) {
        print("Network refresh sent.")
        noNetwork.hidden = true
        searchBar.hidden = false
        self.getMovieData()
        print("loading movies")

        

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UICollectionViewCell
        let indexPath = collectionView.indexPathForCell(cell)
        let movie = filteredMovies[indexPath!.row]
        

        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
