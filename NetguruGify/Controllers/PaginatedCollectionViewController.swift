//
//  PaginatedCollectionViewController.swift
//  NetguruGify
//
//  Created by Michal Ziobro on 22/08/2019.
//  Copyright © 2019 Netguru Task. All rights reserved.
//

import UIKit

class PaginatedCollectionViewController<Element : Equatable>: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // MARK: - MODEL
    var currentPage = 1
    let limit = 25
    
    var fetchingOffset : Int { return 6 }
    
    var shouldShowLoadingCell = false
    
    var elements : [Element] = []
    
    var isFiltered : Bool = false
    
    var filteredCurrentPage = 1
    var filteredShouldShowLoadingCell = false
    
    var filteredElements : [Element] = []
    

    lazy var collectionViewLayout : UICollectionViewLayout = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        return layout
    }()
    
    lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configCollectionView()
        configRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentPage = 1
        loadContent(refreshing: true)
    }

    // MARK: - SETUP VIEWS
    private func configCollectionView() {
        
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        
        collectionView.register(SpinnerCollectionViewCell.self, forCellWithReuseIdentifier: SpinnerCollectionViewCell.identifier)
        //collectionView.register(GifyCollectionViewCell.self, forCellWithReuseIdentifier: GifyCollectionViewCell.identifier)
        collectionView.register(elementCellClass, forCellWithReuseIdentifier: "Element Cell")
    }
    
    private func configRefreshControl() {
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        collectionView.refreshControl?.beginRefreshing()
    }
    
    open var elementCellClass: AnyClass {
        fatalError("Not provided Element Cell Class")
    }
    
    // MARK: - LOADING CONTENT
    open func loadContent(refreshing: Bool = false, completion: (() -> Void)? = nil) {
        fatalError("Not implemented method loadContent!")
    }
    
    open func loadFilteredContent() {
        
        filteredShouldShowLoadingCell = false
        filteredElements = elements.filter { isIncludedInFiltered($0) }
        collectionView.reloadData()
    }
    
    func loadMoreFilteredContent() {
        filteredCurrentPage += 1
        
        loadFilteredContent()
    }
   
    
    func loadHandler(_ elements: [Element]?, _ metadata: PaginationMetadata, _ refreshing: Bool, completion: (() -> Void)? = nil) -> Void {
        
        DispatchQueue.main.async {
            if let elements = elements {
                refreshing ? self.replaceData(elements) : self.appendData(elements)
            }
            
            self.updateCollectionView(metadata)
            completion?()
        }
    }
    
    func replaceData(_ elements: [Element]) {
        self.elements = elements
    }
    
    func appendData(_ elements: [Element]) {
        for element in elements {
            // append only unique elements
            if !self.elements.contains(element) {
                self.elements.append(element)
            }
        }
    }
    
    func updateCollectionView(_ metadata: PaginationMetadata) {
        self.shouldShowLoadingCell = currentPage < metadata.pages
        self.collectionView.refreshControl?.endRefreshing()
        self.collectionView.reloadData()
    }
    
    func loadMoreContent() {
        currentPage += 1
        loadContent()
    }

    @objc func refreshContent() {
        currentPage = 1
        loadContent(refreshing: true)
    }
    
    private func isSpinnerCell(indexPath: IndexPath) -> Bool {
        
        guard shouldShowLoadingCell else { return false }
        
        // is the row past the last elements cell
        return indexPath.row == self.elements.count
    }
    
    private func isFilteredSpinnerCell(indexPath: IndexPath) -> Bool {
        
        guard isFiltered && filteredShouldShowLoadingCell else { return false }
        
        return indexPath.row == filteredElements.count
    }
    
    // MARK: - COLLECTION VIEW
    @objc open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @objc open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFiltered {
            return filteredShouldShowLoadingCell ? filteredElements.count + 1 : filteredElements.count
        }
        
        return shouldShowLoadingCell ? elements.count + 1 : elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isSpinnerCell(indexPath: indexPath) || isFilteredSpinnerCell(indexPath: indexPath) {
            
            let spinnerCell = collectionView.dequeueReusableCell(withReuseIdentifier: SpinnerCollectionViewCell.identifier, for: indexPath) as! SpinnerCollectionViewCell
            //spinnerCell.contentView.backgroundColor = .red
            spinnerCell.spinner.startAnimating()
            return spinnerCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Element Cell", for: indexPath) as! ElementCollectionViewCell<Element>
        
        cell.config(with: element(for: indexPath), indexPath.row)
        
        return cell
    }
    
    func element(for indexPath: IndexPath) -> Element {
        
        if isFiltered {
            return filteredElements[indexPath.row]
        }
        
        return elements[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       
        if isFiltered {
            guard indexPath.row >= filteredCurrentPage * limit - fetchingOffset else { return }
            
            loadMoreFilteredContent()
        } else {
            
            guard indexPath.row >= currentPage*limit - fetchingOffset else { return }
            
            loadMoreContent()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = (collectionView.bounds.width - 16) / CGFloat(columns) - 8
        let height = width * aspectRatio
        
        if isSpinnerCell(indexPath: indexPath) || isFilteredSpinnerCell(indexPath: indexPath) {
            return CGSize(width: collectionView.bounds.width - 16, height: 20)
        }
        
        return CGSize(width: width, height: height)
    }
    
    open var columns : Int {
        var columns : Int = 2
        if UIScreen.main.bounds.width > 400 {
            columns = 3
        }
        if UIScreen.main.bounds.width > 600 {
            columns = 4
        }
        return columns
    }
    
    open var rows : Int {
        let width = (collectionView.bounds.width - 16) / CGFloat(columns) - 8
        let height = width * aspectRatio
        
        return Int((collectionView.bounds.height - 16) / height)
    }
    
    open var aspectRatio : CGFloat {
        return 1.0/1.0
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func isIncludedInFiltered(_ element: Element) -> Bool {
        return true
    }
}
