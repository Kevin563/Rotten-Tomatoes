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
    var detailTextViewFrame: CGRect!
    var synopsisFrame: CGRect!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.movieTitle.text = self.movie.title + " (\(self.movie.year))"
        self.rating.text = "Critics Score: \(self.movie.ratings_critics_score), Audience Score: \(self.movie.ratings_audience_score)"
        self.mapp_rating.text = self.movie.mpaa_rating
        self.synopsis.text = self.movie.synopsis
        title = self.movie.title
        
        self.detailTextViewFrame = self.detailTextView.frame
        self.synopsisFrame = self.synopsis.frame
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var imgurl = self.movie.posters_original
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
        UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            if sender.direction == UISwipeGestureRecognizerDirection.Up {
                var viewPosition = CGPointMake(self.detailTextView.frame.origin.x, self.detailTextView.frame.origin.y - 150)
                var textPosition = CGPointMake(self.synopsis.frame.origin.x, self.synopsis.frame.origin.y)
                
                self.detailTextView.frame = CGRectMake(viewPosition.x, viewPosition.y, self.detailTextView.frame.size.width, self.detailTextView.frame.size.height + 150)
            }
            else if sender.direction == UISwipeGestureRecognizerDirection.Down {
                self.detailTextView.frame = self.detailTextViewFrame
                self.synopsis.frame = self.synopsisFrame
            }
        }, completion: nil)
    }
}
