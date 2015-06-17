//
//  MovieListsViewController.swift
//  kevin563-Week1
//
//  Created by Kevin Chang on 2015/6/13.
//  Copyright (c) 2015年 Kevin Chang. All rights reserved.
//

import UIKit

class MovieListsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet var alertView: UIView!
    @IBOutlet var msgLabel: UILabel!
    @IBOutlet var moviesView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    let tomatoesAPI = TomatoesAPI(url: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=dagqdghwaq3e3mxyrp7kmmj5&limit=20&country=us")
    var movies: [TomatoesEntity]!
    var searchResult: [TomatoesEntity]!
    var util = Utility()
    var loading = UIActivityIndicatorView()
    var refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loading.center = self.moviesView.center
        self.loading.color = UIColor.orangeColor()
        self.loadingStatus(true)
        self.alertView.frame = CGRectZero
        
        // Monitor Network status 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "delectNetwork:", name: kReachabilityChangedNotification, object: nil)
        
        // Refresh
        self.refresh.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.moviesView.insertSubview(self.refresh, atIndex: 0)
        
        // Async call API
        self.movies = [TomatoesEntity]()
        tomatoesAPI.loadTomatoes(didLoadMovies)
        
        view.addSubview(self.loading)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadingStatus(status: Bool)
    {
        if status {
            self.moviesView.separatorColor = UIColor.blackColor()
            self.loading.startAnimating()
        }
        else {
            self.moviesView.separatorColor = UIColor.grayColor()
            self.loading.stopAnimating()
        }
    }
    
    func didLoadMovies(movies: [AnyObject]) {
        self.movies = movies as! [TomatoesEntity]
        self.moviesView.reloadData()
        self.loadingStatus(false)
    }
    
    // refresh data from api
    func onRefresh() {
        self.searchResult = nil
        tomatoesAPI.loadTomatoes(didLoadMovies)
        var delayInSeconds = 1.5
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.refresh.endRefreshing()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchResult != nil {
            return self.searchResult.count
        }
        else {
            return self.movies.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MovieViewCell
        var cellsdata: [TomatoesEntity]!
        
        if self.searchResult != nil {
            cellsdata = self.searchResult
        }
        else {
            cellsdata = self.movies
        }
        
        cell.title.text = cellsdata[indexPath.row].title

        // Same labelText but different sytle
        var mapp_rating = NSMutableAttributedString(string: cellsdata[indexPath.row].mpaa_rating + " " + cellsdata[indexPath.row].synopsis)
        var range = NSMakeRange(0, count(cellsdata[indexPath.row].mpaa_rating))
        var boldFont = UIFont.boldSystemFontOfSize(13.0)
        mapp_rating.addAttribute(NSFontAttributeName, value: boldFont, range: range)
        cell.synosis.attributedText = mapp_rating
        
        // async load image
        var imgurl = NSURL(string: cellsdata[indexPath.row].posters_thumbnail)!
        cell.poster.setImageWithUrl(imgurl, placeHolderImage: nil)

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // delect Newwork
    func delectNetwork (notification: NSNotification) {
        util.networkStatus(notification, showWin: self.alertView, msgLabel: self.msgLabel, message: "⚠️ Network Error")
        tomatoesAPI.loadTomatoes(didLoadMovies)
        self.loadingStatus(false)
    }
    
    // search filer
    func filterContentForSearchText (searchText: String) {
        self.searchResult = self.movies.filter({(movie: TomatoesEntity) -> Bool in
            let titleMatch = movie.title.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return titleMatch != nil
        })
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchResult = nil
        searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
        self.moviesView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchText)
        self.moviesView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! MovieViewCell
        var cellsdata: [TomatoesEntity]!
        
        if self.searchResult != nil {
            cellsdata = self.searchResult
        }
        else {
            cellsdata = self.movies
        }
        
        let indexPath = self.moviesView.indexPathForCell(cell)
        let movie = cellsdata[indexPath!.row] as TomatoesEntity
        var destinationVC = segue.destinationViewController as! MovieDetailViewController
        destinationVC.movie = movie
        
        // hidden tab bar
        destinationVC.hidesBottomBarWhenPushed = true
    }
}
