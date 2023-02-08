//
//  ViewController.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 22/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import UIKit

class GifyListViewController: PaginatedCollectionViewController<Gify> {
    
    public var gifyService : GifyServiceInterface = GifyService()
    
    private var showStarred : Bool = false
    private var starred : Array<Gify> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configBarButtons()
    }
    
    override var elementCellClass: AnyClass {
        return GifyCollectionViewCell.self
    }
 
    override func loadContent(refreshing: Bool = false, completion: (() -> Void)? = nil) {
        
        let offset = (currentPage - 1) * limit
        
        gifyService.getGifyData(offset: offset) { [weak self] (data, error) in
            
            guard let data = data, error == nil else {
                print("ERROR: loading data... maybe show alert")
                return
            }
            
            self?.loadHandler(data.data, data.pagination, refreshing, completion: completion)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if showStarred {
            return starred.count
        }
        
        return super.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if showStarred {
            
            let gify = starred[indexPath.row]
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Element Cell", for: indexPath) as! GifyCollectionViewCell
            cell.config(with: gify, indexPath.row)
            cell.button.isHidden = true
            cell.imageView.alpha = 1.0
            
            return cell
        }
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if let gifyCell = cell as? GifyCollectionViewCell {
            gifyCell.delegate = self
            
            if starred.contains(where: { $0.id == gifyCell.id }) {
                gifyCell.button.isSelected = true
                gifyCell.imageView.alpha = 0.5
            } else {
                gifyCell.button.isSelected = false
                gifyCell.imageView.alpha = 1.0
            }
            
            gifyCell.button.isHidden = false
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let gify = showStarred ? starred[indexPath.row] : elements[indexPath.row]
        
        let vc = GifyDetailsViewController()
        vc.gify = gify
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - GIFY DETAILS DELEGATE
extension GifyListViewController : GifyDetailsDelegate {
    
    func isGifyStarred(_ gify: Gify) -> Bool {
        return starred.contains(gify)
    }
    
    func setGifyStarred(_ gify: Gify, isStarred: Bool) {
        
        if isStarred {
            if !starred.contains(gify) {
                starred.append(gify)
            }
        } else {
            starred.removeAll(where: { $0 == gify })
        }
    }
    
}

// MARK: - BAR BUTTONS
extension GifyListViewController {
    
    private func configBarButtons() {
        
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    var barButton: UIBarButtonItem {
        
        let button = UIBarButtonItem(image: UIImage(named: "Star"), style: .plain, target: self, action: #selector(didTapStar(_:)))
        button.tintColor = .orange
        return button
    }
    
    @objc func didTapStar(_ sender: UIBarButtonItem) {
        
        self.showStarred = !self.showStarred
        
        collectionView.reloadData()
    }
    
}

// MARK : CELL DELEGATE
extension GifyListViewController : GifyCellDelegate {
    func didSelectGify(_ cell: GifyCollectionViewCell, id: String) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        if !starred.contains(elements[indexPath.row]) {
            starred.append(elements[indexPath.row])
        }
        
        print("Starred: \(starred)")
    }
    
    func didDeselectGify(_ cell: GifyCollectionViewCell, id: String) {
        
        starred.removeAll { $0.id == id }
        
        print("Starred: \(starred)")
    }
}
