//
//  AsyncImageView.swift
//  TABTest
//
//  Created by master on 4/22/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

fileprivate let imageCache = NSCache<NSString, AnyObject>()

protocol AsyncImageViewProtocol
{
    func imageDidLoad(size : CGSize)
}

class AsyncImageView: UIImageView {

    var delegate : AsyncImageViewProtocol!
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
    
    func loadImageUsingCache(withUrl urlString : String)
    {
        let url = URL(string: urlString)
        self.image = nil
        
      
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.setImage(theImage: cachedImage)
            return
        }
        
        // if not, download image from url
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
