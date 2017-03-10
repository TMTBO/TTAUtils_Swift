//
//  BaseProtocol.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 06/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import UIKit

/// A closure to configure tableView cell
typealias ConfigureTableViewCellClosure = (UITableView?, IndexPath) -> (UITableViewCell)

/// Aclousre to configure collection cell
typealias ConfigureCollectionViewCellClosure = (UICollectionView?, IndexPath) -> (UICollectionViewCell)

protocol BaseDataSourceProtocol: NSObjectProtocol {
    
    associatedtype T
//    associatedtype HeaderT
//    associatedtype FooterT
    
    // DataSource
    var groups: [[T]] { get set }
//    var sectionHeader: [HeaderT] { get set }
//    var sectionFooter: [FooterT] { get set }
    
}

extension BaseDataSourceProtocol {
    
    // Data featch functions
    func group(at section: Int) -> [T]? {
        return groups[section]
    }
    
    func item(at indexPath: IndexPath) -> T? {
        return group(at: indexPath.section)?[indexPath.row]
    }
    
    func sectionHeader<HeaderT>(at section: Int) -> HeaderT {
        return "Hello world" as! HeaderT
    }
    
    func sectionFooter<FooterT>(at section: Int) -> FooterT {
        return "Hello world" as! FooterT
    }
    
}

class BaseCellProtocolItem: NSObject {
    var cellClass: AnyClass
    var cellReuseId: String
    
    init(`class`: AnyClass, reuseId: String) {
        cellClass = `class`
        cellReuseId = reuseId
        super.init()
    }
}

/****************************** TargetAction ****************************/
// MARK: - TargetAction

typealias TTASelector = (Any?) -> () -> ()

protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper : TargetAction {
    var target: Any?
    let action: TTASelector?
    func performAction() -> () {
        guard let t = target else { return }
        guard let currentAction = action else { return }
        currentAction(t)()
    }
}
enum TTAControlEvents {
    case touchUpInside
    case valueChanged
    // ...
}

protocol TTAControl: class {
    var actions: [TTAControlEvents: TargetAction]? { get set}
    
}

extension TTAControl {
    func addTarget(target: Any?, action: TTASelector?, controlEvent: TTAControlEvents) {
        actions?[controlEvent] = TargetActionWrapper(target: target, action: action)
    }
    func removeTargetForControlEvent(controlEvent: TTAControlEvents) {
        actions?[controlEvent] = nil
    }
    func performActionForControlEvent(controlEvent: TTAControlEvents) {
        actions?[controlEvent]?.performAction()
    }
}
