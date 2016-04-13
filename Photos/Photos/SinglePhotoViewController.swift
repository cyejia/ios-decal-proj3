//
//  SinglePhotoViewController.swift
//  Photos
//
//  Created by Yejia Chen on 4/9/16.
//  Copyright © 2016 iOS DeCal. All rights reserved.
//

import UIKit

class SinglePhotoViewController: UIViewController {
    
    @IBOutlet weak var usernameUILabel: UILabel!
    @IBOutlet weak var singleImageUIImageView: UIImageView!
    @IBOutlet weak var likesUILabel: UILabel!
    @IBOutlet weak var dateUILabel: UILabel!
    @IBOutlet weak var heartImageView: UIImageView!
    
    
    var photo : Photo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        usernameUILabel.text = "@" + photo!.username!
        likesUILabel.text = String(photo!.likes!)
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateUILabel.text = dateFormatter.stringFromDate(photo!.dateCreated)
        
        let downloadQueue = dispatch_queue_create("com.Photos.processdownload", nil)
        
        dispatch_async(downloadQueue) {
            let data = NSData(contentsOfURL: NSURL(string:self.photo!.url)!)
            let img = UIImage(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                self.singleImageUIImageView.image = img
            }
        }
        
        let imageView = heartImageView
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("heartTapped:"))
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
    }
    
    func heartTapped(img : AnyObject) {
        let filledHeart = UIImage(named: "Hearts Filled-100")
        let openHeart = UIImage(named: "Hearts-100")
        
        if imagesAreEqual(heartImageView.image!, imageB: openHeart!) {
            heartImageView.image = filledHeart
            likesUILabel.text = String(Int(likesUILabel.text!)! + 1)
            
        } else {
            heartImageView.image = openHeart
            likesUILabel.text = String(Int(likesUILabel.text!)! - 1)

        }
//        print("\(imagesAreEqual(heartImageView.image!, imageB: filledHeart!))")
//        print("\(imagesAreEqual(heartImageView.image!, imageB: openHeart!))")
    }
    
    func imagesAreEqual(imageA: UIImage, imageB: UIImage) -> Bool {
        let dataA = UIImagePNGRepresentation(imageA)
        let dataB = UIImagePNGRepresentation(imageB)
        
        return dataA == dataB
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
