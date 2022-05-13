//
//  MyCollectionViewCell.swift
//  Collection View
//
//  Created by Deepak Rathore on 11/05/22.
//

import UIKit

struct DogImage : Codable {
    let status: String
    let message: String
}

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = "MyCollectionViewCell"

    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func getRandomDogBreedImage() {
        let imageAPI = URL(string: "https://dog.ceo/api/breeds/image/random")
        let getRandomImageUrlTask = URLSession.shared.dataTask(with: imageAPI!) { (data, response, error) in
            guard let data = data else{
                return
            }
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            guard let imageURL = URL(string: imageData.message) else {
                return
            }
            let downloadImageTask = URLSession.shared.dataTask(with: imageURL, completionHandler: {(data, response, error) in
                guard let data = data else {
                    return
                }
                let downloadedImage = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imageView.image = downloadedImage
                }
            })
            downloadImageTask.resume()
        }
        getRandomImageUrlTask.resume()
    }

}
