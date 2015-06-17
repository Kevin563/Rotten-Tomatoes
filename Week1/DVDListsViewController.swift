//
//  DvdDetailViewController.swift
//  Week1
//
//  Created by Kevin Chang on 2015/6/17.
//  Copyright (c) 2015年 Kevin Chang. All rights reserved.
//

import UIKit

class DVDListsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet var dvdsView: UICollectionView!
    @IBOutlet var loading: UIActivityIndicatorView!
    @IBOutlet var searchBar: UISearchBar!
    
    let tomatoesAPI = TomatoesAPI(url: "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=7ue5rxaj9xn4mhbmsuexug54&limit=20&country=us")
    var dvds: [TomatoesEntity]!
    var searchResult: [TomatoesEntity]!
    var util = Utility()
    var refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loading.center = self.dvdsView.center
        self.loading.color = UIColor.orangeColor()
        self.loadingStatus(true)
        
        // Refresh
        self.refresh.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.dvdsView.insertSubview(self.refresh, atIndex: 0)
        
        // Async call API
        self.dvds = [TomatoesEntity]()
        tomatoesAPI.loadTomatoes(didLoadDVDs)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadingStatus(status: Bool)
    {
        if status {
            self.loading.startAnimating()
        }
        else {
            self.loading.stopAnimating()
        }
    }
    
    func didLoadDVDs(dvds: [AnyObject]) {
        self.dvds = dvds as! [TomatoesEntity]
        self.dvdsView.reloadData()
        self.loadingStatus(false)
    }
    
    // refresh data from api
    func onRefresh() {
        self.searchResult = nil
        tomatoesAPI.loadTomatoes(didLoadDVDs)
        var delayInSeconds = 1.5
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.refresh.endRefreshing()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchResult != nil {
            return self.searchResult.count
        }
        else {
            return self.dvds.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.dvdsView.dequeueReusableCellWithReuseIdentifier("dvdcell", forIndexPath: indexPath) as! DVDCollectionViewCell
        var cellsdata: [TomatoesEntity]!
        
        if self.searchResult != nil {
            cellsdata = self.searchResult
        }
        else {
            cellsdata = self.dvds
        }
        
        cell.title.text = cellsdata[indexPath.row].title
        
        cell.mapp.text = cellsdata[indexPath.row].mpaa_rating
        cell.ratings_audience_score.text = "\(cellsdata[indexPath.row].ratings_audience_score)"
        cell.ratings_critics_score.text = "\(cellsdata[indexPath.row].ratings_critics_score)"
        
        // async load image
        var imgurl = NSURL(string: self.dvds[indexPath.row].posters_thumbnail)!
        cell.poster.setImageWithUrl(imgurl, placeHolderImage: nil)
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
  
    // search filer
    func filterContentForSearchText (searchText: String) {
        self.searchResult = self.dvds.filter({(dvd: TomatoesEntity) -> Bool in
            let titleMatch = dvd.title.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return titleMatch != nil
        })
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchResult = nil
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchResult = nil
        searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
        self.dvdsView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchText)
        self.dvdsView.reloadData()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! DVDCollectionViewCell
        var cellsdata: [TomatoesEntity]!
        
        if self.searchResult != nil {
            cellsdata = self.searchResult
        }
        else {
            cellsdata = self.dvds
        }
        
        let indexPath = self.dvdsView.indexPathForCell(cell)
        let movie = cellsdata[indexPath!.row] as TomatoesEntity
        var destinationVC = segue.destinationViewController as! MovieDetailViewController
        destinationVC.movie = movie
        
        // hidden tab bar
        destinationVC.hidesBottomBarWhenPushed = true
    }

}
