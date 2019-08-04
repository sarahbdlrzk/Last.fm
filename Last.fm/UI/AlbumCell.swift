//
//  AlbumCell.swift
//  CVVM
//
//  Created by Tibor Bödecs on 2018. 04. 12..
//  Copyright © 2018. Tibor Bödecs. All rights reserved.
//

import UIKit
import AlamofireImage


extension UInt64 {
    
    func megabytes() -> UInt64 {
        return self * 1024 * 1024
    }
    
}

class AlbumCell: CollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var detailTextLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    let imageCache = AutoPurgingImageCache(
        memoryCapacity: UInt64(100).megabytes(),
        preferredMemoryUsageAfterPurge: UInt64(60).megabytes()
    )
    
    let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.textLabel.textColor = .black

        self.detailTextLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.detailTextLabel.textColor = .darkGray
        
        self.imageView.layer.cornerRadius = 8
        self.imageView.layer.masksToBounds = true
    }
    
    override func reset() {
        super.reset()
        
        self.textLabel.text = nil
        self.detailTextLabel.text = nil
        self.imageView.image = nil
    }
    
    //MARK: = Image Caching
    
    func cache(_ image: UIImage, for url: String) {
        imageCache.add(image, withIdentifier: url)
    }
    
    func cachedImage(for url: String) -> UIImage? {
        return imageCache.image(withIdentifier: url)
    }
    
    func loadImage(imageUrl: String) {
        if let image = self.cachedImage(for: imageUrl) {
            DispatchQueue.main.async {
                self.imageView.image = image
                print("image loaded from cach")
            }
            return
        }
        download(imageUrl: imageUrl)
    }
    
    func download(imageUrl: String) {
        
        guard let url = URL(string: imageUrl) else { return }
        let urlRequest = URLRequest(url: url)
        imageDownloader.download(urlRequest) { response in
            switch response.result {
            case .success(let image):
                self.cache(image, for: imageUrl)
                print("image received")
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                print("failed to downlaod image \(error)")
                
            }
        }
    }
}
