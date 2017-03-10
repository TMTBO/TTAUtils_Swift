//
//  BaseDataSource.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 06/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

class BaseDataSource<T, HeaderT, FooterT>: NSObject, BaseDataSourceProtocol, UITableViewDataSource, UICollectionViewDataSource {
    
    var groups: [[T]] = []
    var sectionHeader: [HeaderT] = []
    var sectionFooter: [FooterT] = []
    
    var configureTableViewCellClosure: ConfigureTableViewCellClosure?
    var configureCollectionViewCellClosure: ConfigureCollectionViewCellClosure?
    
    init?(view: UIView, cellItems: [BaseCellProtocolItem], configureTableViewCellClosure: ConfigureTableViewCellClosure?, configureCollectionViewCellClosure: ConfigureCollectionViewCellClosure? = nil) {
        self.configureTableViewCellClosure = configureTableViewCellClosure
        self.configureCollectionViewCellClosure = configureCollectionViewCellClosure
        super.init()
        
        registerCells(view: view, items: cellItems)
    }
    
    /// Set data source for the tableView or collectionView
    ///
    /// - Parameters:
    ///   - view: A tableVeiw or a collectionView
    ///   - groups: the data source
    open func set(view: UIView, groups: [[T]]) {
        self.groups = groups
        if let tableView = view as? UITableView {
            tableView.reloadData()
        } else if let collectionView = view as? UICollectionView {
            collectionView.reloadData()
        } else {
            fatalError("The view is NETHER a UITableView NOR a UICollectionView: \(view)")
        }
    }
    
    // MARK: - UITableViewDataSource
    @available(iOS 2.0, *)
    public func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group(at: section).count
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let configureCellClosure = configureTableViewCellClosure else {
            fatalError("configureTableViewCellClosure is nil, Check the Code")
        }
        return configureCellClosure(tableView, indexPath)
    }

    // MARK: - UICollectionViewDataSource
    @available(iOS 6.0, *)
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groups.count
    }

    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return group(at: section).count
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        guard let configureCellClosure = configureCollectionViewCellClosure else {
            fatalError("configureCollectionViewCellClosure is nil, Check the code")
        }
        return configureCellClosure(collectionView, indexPath)
    }
}

// MARK: - Data Fetcher Founctions

extension BaseDataSource {
    
    /// Fetch the data of rows in current section from the datasource
    ///
    /// - Parameter section: Current section
    /// - Returns: The data of rows in current section
    internal func group(at section: Int) -> [T] {
        return groups[section]
    }
    
    
    
    /// Fetch the data of row for current indexPath
    ///
    /// - Parameter indexPath: Current indexPath
    /// - Returns: The data of row
    internal func item(at indexPath: IndexPath) -> T {
//        guard let items = group(at: indexPath.section) else { return nil }
        return item[indexPath.row]
    }
    
    /// Fetch the Header for current section
    ///
    /// - Parameter section: Current section
    /// - Returns: The data of header in current section
    open func sectionHeader(at section: Int) -> HeaderT {
        return sectionHeader[section]
    }
    
    /// Fetch the Footer for current section
    ///
    /// - Parameter section: Current section
    /// - Returns: The data of footer in current section
    open func sectionFooter(at section: Int) -> FooterT {
        return sectionFooter[section]
    }
    
    /// Set the section headers
    ///
    /// - Parameter headers: section headers
    open func setHeaders(headers: [HeaderT]) {
        self.sectionHeader = headers
    }
    
    /// Set the section footers
    ///
    /// - Parameter footers: section footers
    open func setFooters(footers: [FooterT]) {
        self.sectionFooter = footers
    }
}

// MARK: - Private Founction

extension BaseDataSource {
    
    /// Register the tableView or collectionView cells
    ///
    /// - Parameters:
    ///   - view: A tableView or a collectionView
    ///   - items: Cell items with a property of `cellClass` and a property of `cellReuseId`
    fileprivate func registerCells(view: UIView, items: [BaseCellProtocolItem]) {
        if let tableView = view as? UITableView {
            for item in items {
                tableView.register(item.cellClass, forCellReuseIdentifier: item.cellReuseId)
            }
        } else if let collectionView = view as? UICollectionView {
            for item in items {
                collectionView.register(item.cellClass, forCellWithReuseIdentifier: item.cellReuseId)
            }
        } else {
            fatalError("The view is NETHER a UITableView NOR UICollectionView: \(view)")
        }
    }
}
