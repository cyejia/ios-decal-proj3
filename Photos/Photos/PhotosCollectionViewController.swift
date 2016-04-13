//
//  PhotosCollectionViewController.swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
                
    @IBOutlet var collectionViewOutlet: UICollectionView!
    
    var photos: [Photo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = InstagramAPI()
        api.loadPhotos(didLoadPhotos)
        // FILL ME IN
    }

    /* 
     * IMPLEMENT ANY COLLECTION VIEW DELEGATE METHODS YOU FIND NECESSARY
     * Examples include cellForItemAtIndexPath, numberOfSections, etc.
     */
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (photos == nil) {
            return 20
        } else {
            return photos.count
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionViewOutlet.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PhotosCollectionViewCell
        if (photos != nil) {
            let photo = photos[indexPath.row]
            let imageView = cell.imageView
            loadImageForCell(photo, imageView: imageView)
        }
        return cell
    }
    
    /* Creates a session from a photo's url to download data to instantiate a UIImage. 
       It then sets this as the imageView's image. */
    func loadImageForCell(photo: Photo, imageView: UIImageView) {
        let downloadQueue = dispatch_queue_create("com.Photos.processdownload", nil)
        
        dispatch_async(downloadQueue) {
            let data = NSData(contentsOfURL: NSURL(string:photo.url!)!)
            let img = UIImage(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = img
            }
        }
    }
    
    /* Completion handler for API call. DO NOT CHANGE */
    func didLoadPhotos(photos: [Photo]) {
        self.photos = photos
        self.collectionView!.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selectPhotoSegue") {
            let cell = sender as! PhotosCollectionViewCell
            let indexPath = self.collectionView!.indexPathForCell(cell)
            let destination = segue.destinationViewController as! SinglePhotoViewController
            
            destination.photo = photos[indexPath!.row]
            
        }
    }
}

