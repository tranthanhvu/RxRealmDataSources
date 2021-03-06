//
//  RxRealm extensions
//
//  Copyright (c) 2016 RxSwiftCommunity. All rights reserved.
//  Check the LICENSE file for details
//

import Foundation

import RealmSwift
import RxSwift
import RxCocoa
import RxRealm

#if os(iOS)
// MARK: - iOS / UIKit

import UIKit
extension Reactive where Base: UITableView {

    public func realmChanges<E>(_ dataSource: RxTableViewRealmDataSource<E>)
        -> RealmBindObserver<E, AnyRealmCollection<E>, RxTableViewRealmDataSource<E>> where E: Object {

            return RealmBindObserver(dataSource: dataSource) {ds, results, changes in
                if ds.tableView == nil {
                    ds.tableView = self.base
                }
                
                if ds.tableView?.dataSource == nil {
                    ds.tableView?.dataSource = ds
                }
                ds.applyChanges(items: AnyRealmCollection<E>(results), changes: changes)
            }
    }
}

extension Reactive where Base: UICollectionView {

    public func realmChanges<E>(_ dataSource: RxCollectionViewRealmDataSource<E>)
        -> RealmBindObserver<E, AnyRealmCollection<E>, RxCollectionViewRealmDataSource<E>> where E: Object {

            return RealmBindObserver(dataSource: dataSource) {ds, results, changes in
                if ds.collectionView == nil {
                    ds.collectionView = self.base
                }
                
                if ds.collectionView?.dataSource == nil {
                    ds.collectionView?.dataSource = ds
                }
                ds.applyChanges(items: AnyRealmCollection<E>(results), changes: changes)
            }
    }
}


#elseif os(OSX)
// MARK: - macOS / Cocoa

import Cocoa
extension Reactive where Base: NSTableView {

    public func realmChanges<E>(_ dataSource: RxTableViewRealmDataSource<E>)
        -> RealmBindObserver<E, AnyRealmCollection<E>, RxTableViewRealmDataSource<E>> where E: Object {

            base.delegate = dataSource
            base.dataSource = dataSource

            return RealmBindObserver(dataSource: dataSource) {ds, results, changes in
                if dataSource.tableView == nil {
                    dataSource.tableView = self.base
                }
                ds.applyChanges(items: AnyRealmCollection<E>(results), changes: changes)
            }
    }
}

extension Reactive where Base: NSCollectionView {

    public func realmChanges<E>(_ dataSource: RxCollectionViewRealmDataSource<E>)
        -> RealmBindObserver<E, AnyRealmCollection<E>, RxCollectionViewRealmDataSource<E>> where E: Object {

            return RealmBindObserver(dataSource: dataSource) {ds, results, changes in
                if ds.collectionView == nil {
                    ds.collectionView = self.base
                }
                ds.collectionView?.dataSource = ds
                ds.applyChanges(items: AnyRealmCollection<E>(results), changes: changes)
            }
    }
}

#endif
