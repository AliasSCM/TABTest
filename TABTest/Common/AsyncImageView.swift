//
//  AsyncImageView.swift
//  TABTest
//
//  Created by master on 4/22/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

/// Extending UIImage to handle chaching

/// Image Cache to store images loaded from URL's. Doing this to improve performance so that the Image is not fetched everytime, rather cache is used. This is provate only to tis file and should not be acessed from outside
fileprivate let imageCache = NSCache<NSString, AnyObject>()
/// AsyncImageView Protocol. To notify view controllers when image has loaded from remote
/// important : Must be implemented. This method is used to adjust layout of view controlller like table view or collection view depending on the size of the image.
protocol AsyncImageViewProtocol
{
    func imageDidLoad(size : CGSize)
}
/// Subclass of UIImageView that handles remote loading of Images from URL asynchronously.
class AsyncImageView: UIImageView {
    ///delegate to convey to when image download is complete
    var delegate : AsyncImageViewProtocol!
    /// Computer property to set constraints on the image view depending on the size and proportions of the downloaded image.
    var aspectConstraint: NSLayoutConstraint? {
        willSet {
            if((aspectConstraint) != nil) {
                self.removeConstraint(self.aspectConstraint!)
            }
        }
        didSet {
            if(aspectConstraint != nil) {
                self.addConstraint(self.aspectConstraint!)
            }
        }
    }
    /// Private function to set the image and cnstraints after image download is complete.
    /// - important: Should be called only after image downlaod is complete
    /// - parameter theImage:The dowlaoded UIImage
    fileprivate func setImage(theImage : UIImage)
    {
        let aspect = theImage.size.width / theImage.size.height
     self.aspectConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.height, multiplier: aspect, constant: 0)
        
        self.image = theImage
        if(self.delegate != nil)
        {
            self.delegate.imageDidLoad(size: CGSize.init(width:theImage.size.width  , height: theImage.size.height))
        }
    }
    /// Public method that loades image from URL. This uses the cache to check if the image first exists in the cache, if it does the image will be returned from cache
    /// - parameter urlString : The url as a string from which image has to be downlaoded
    func loadImageUsingCache(withUrl urlString : String)
    {
        let url = URL(string: urlString)
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.setImage(theImage: cachedImage)
            return
        }
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let theImage = UIImage(data: data!) {
                    imageCache.setObject(theImage, forKey: urlString as NSString)
                    self.setImage(theImage: theImage)
                }
            }
            }).resume()
    }
    
}
