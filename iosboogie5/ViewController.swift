//
//  ViewController.swift
//  iosboogie5
//
//  Created by Ashley Ansell on 10/7/15.
//  Copyright © 2015 Ashley Ansell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var movieNames = [String]()
    var posters = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var textBox: UITextField!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // called when the button is called
        // take our movie names and pass them along
        if let movieCtrl = segue.destinationViewController as? MyTableViewController {
            movieCtrl.movieNames = self.movieNames
            movieCtrl.posters = self.posters
            self.movieNames = [String]()
            self.posters = [String]()
        }
    }
    
    @IBAction func clickDerp(sender: AnyObject) {
        print("derp!")
        
        let searchString = textBox.text!
        
        let escapedString = searchString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
        // step 1: make URL string
        let urlString = "http://www.omdbapi.com/?s=\(escapedString)"
        
        // step 2: make a URL
        if let url = NSURL(string: urlString) {
            // step 3: make a URL request from the URL
            let request = NSURLRequest(URL: url)
            
            // step 4: use the session to create data task
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                print("RESPONDED")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let data = data {
                        let dataJson = try! NSJSONSerialization.JSONObjectWithData(data, options: [])
                        print(dataJson)
                        
                        if let jsonDict = dataJson as? NSDictionary, movies = jsonDict["Search"] as? NSArray {
                            
                            print(movies)
                            
                            for movie in movies {
                                if let title = movie["Title"] as? String {
                                    self.movieNames.append(title)
                                }
                                if let poster = movie["Poster"] as? String {
                                    self.posters.append(poster)
                                }
                                // look at documentation for UISegue to figure out how to programmatically move to new view 
                                // After data is loaded instead of clicking a different button
                                
                            }
                            self.performSegueWithIdentifier("movies", sender: nil)
                        }
                    }
                })
            }) //this is a class method. It is shared among all instances of NSURLSession (so the whole app)
            
            // step 5: call the request!
            task.resume()
            
        }
        
    }
}

