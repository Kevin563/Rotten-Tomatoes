//
//  MovieDetailViewController.swift
//  Week1
//
//  Created by Kevin Chang on 2015/6/15.
//  Copyright (c) 2015年 Kevin Chang. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet var poster: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var mapp_rating: UILabel!
    @IBOutlet var synopsis: UILabel!
    @IBOutlet var detailTextView: UIView!
    var movie: TomatoesEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.movieTitle.text = self.movie.title + " (\(self.movie.year))"
        self.rating.text = "Critics Score: \(self.movie.ratings_critics_score), Audience Score: \(self.movie.ratings_audience_score)"
        self.mapp_rating.text = self.movie.mpaa_rating
        self.synopsis.text = self.movie.synopsis
        title = self.movie.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var imgurl = self.movie.posters_thumbnail
        self.poster.setImageWithUrl(NSURL(string: imgurl)!, placeHolderImage: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        var imgurl = self.movie.posters_detailed as NSString
        let highres = self.convertPosterUrlStringtoHighRes(imgurl)
        self.poster.setImageWithUrl(NSURL(string: highres as String)!, placeHolderImage: nil)
    }
    
    func convertPosterUrlStringtoHighRes(url: NSString) -> NSString {
        var range = url.rangeOfString(".*cloudfront.net/", options: NSStringCompareOptions.RegularExpressionSearch)
        var returnValue = url
        
        if (range.length > 0) {
            returnValue = url.stringByReplacingCharactersInRange(range, withString: "https://content6.flixster.com/")
        }
        return returnValue
    }
    
    @IBAction func onPullSynopsis(sender: UISwipeGestureRecognizer) {
        
        
        UIView.animateWithDuration(1.0, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            // to try
            self.detailTextView.frame = CGRectMake(self.detailTextView.frame.origin.x, 50, self.detailTextView.frame.size.height, self.detailTextView.frame.size.width)
            }, completion: nil)
//        var point = sender.locationInView(self.detailTextView)
//        var velocity = sender.velocityInView(self.detailTextView)
//        
    }
}
