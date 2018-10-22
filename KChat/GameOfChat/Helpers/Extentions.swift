//
//  Extentions.swift
//  GameOfChat
//
//  Created by ChandlerZou on 2018/10/22.
//  Copyright © 2018 zouhuanlin. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()


extension UIImageView{
    func loadImageWithCacheWithUrlString(urlString: String){
        // check cache
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cacheImage
            return 
            
        }
        
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error{
                print(error)
                return
            }
            DispatchQueue.main.async {
                if let downloadImage = UIImage(data: data!){
                    imageCache.setObject(downloadImage, forKey: urlString as AnyObject)
                    self.image = downloadImage
                }
                
            }
        }
    }
}
