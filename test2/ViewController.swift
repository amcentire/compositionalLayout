//
//  ViewController.swift
//  test2
//
//  Created by McEntire, Allison on 7/25/19.
//  Copyright © 2019 Deloitte Digital. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    
    //TODO: delete colors
    let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange, UIColor.purple]
    
    private var searches: [FlickrSearchResults] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    private let flickr = Flickr()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init collection view
        
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: makeLayout())
        self.collectionView.backgroundColor = UIColor.white
        // set the delegate and dataSource on self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // register our cell
        self.collectionView.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        // place the collectionView in the viewController's view
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
            ])
    }
    
    
    // data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TestCollectionViewCell {
            cell.colorView.backgroundColor = colors[indexPath.row]
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (section: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1.0), heightDimension: NSCollectionLayoutDimension.absolute(44)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),  heightDimension: .absolute(50))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: self.numberOfColumns(section: section))
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            return section
        }
        return layout
    }
    
    func numberOfColumns(section: Int) -> Int {
        switch section {
        case 0:
            return 5
        case 1:
            return 3
        default:
            return 1
        }
    }
    

}

// MARK: - Text Field Delegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 1
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        flickr.searchFlickr(for: textField.text!) { searchResults in
            activityIndicator.removeFromSuperview()
            
            switch searchResults {
            case .error(let error) :
                // 2
                print("Error Searching: \(error)")
            case .results(let results):
                // 3
                print("Found \(results.searchResults.count) matching \(results.searchTerm)")
                self.searches.insert(results, at: 0)
                // 4
                self.collectionView?.reloadData()
            }
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - Private
private extension ViewController {
    func photo(for indexPath: IndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
}
