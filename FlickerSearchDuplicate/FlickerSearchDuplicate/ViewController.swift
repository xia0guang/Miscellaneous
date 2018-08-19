//
//  ViewController.swift
//  FlickerSearchDuplicate
//
//  Created by xiaoguang on 8/5/18.
//  Copyright © 2018 Ray. All rights reserved.
//

import UIKit

let kReusedIdentifier = "FlickrPhotoCell"
let kInset = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
let kItemsPerRow = 3


class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UITextField!
    private var flickrPhotos: [[FlickrPhoto]] = []
    fileprivate let flickr = Flickr(.prod)
    fileprivate var indicator: UIActivityIndicatorView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.searchBar.delegate = self
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.text = nil
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        textField.addSubview(indicator!)
        indicator!.frame = textField.frame
        indicator!.startAnimating()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let searchTerm = textField.text else {
            print("no search text")
            return
        }
        
        self.flickr.searchFlickrForTerm(searchTerm) { searchResult in
            defer {
                self.indicator?.removeFromSuperview()
            }
            self.flickrPhotos.append(searchResult.searchResults)
            self.collectionView.reloadData()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width / CGFloat(kItemsPerRow)) - (kInset.left + kInset.right)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return kInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kInset.bottom
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.flickrPhotos[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.flickrPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kReusedIdentifier, for: indexPath) as? FlickrPhotoCell else {
            return UICollectionViewCell(frame: CGRect.zero)
        }
        let photo = self.flickrPhotos[indexPath.section][indexPath.row]
        if photo.largeImage == nil {
            photo.loadLargeImage { photo, error in
                guard let image = photo.largeImage else {
                    print(error?.description ?? "unknow error")
                    return
                }
                
                cell.imageView.image = image
                //TODO: - what if cell recycled before image be loaded
            }
        } else {
            cell.imageView.image = photo.largeImage
        }
        return cell
    }
}

