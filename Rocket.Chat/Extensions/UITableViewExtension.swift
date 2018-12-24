//
//  UITableViewExtension.swift
//  Rocket.Chat
//
//  Created by Elen on 24/12/2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation


public extension UITableView {
    
    func registerHeaderFooterNib<T:UITableViewHeaderFooterView>(_:T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: Bundle(for: T.self))
        self.register(nib, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }
    
    func registerHeaderFooter<T:UITableViewHeaderFooterView>(_:T.Type, headerFooterViewReuseIdentifier: String = String(describing: T.self)){
        self.register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }
    
    func registerNib<T: UITableViewCell>(_: T.Type){
        let nib = UINib(nibName: String(describing: T.self), bundle: Bundle(for: T.self))
        self.register(nib, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func register<T: UITableViewCell>(_: T.Type) {
        self.register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath, _:T.Type) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else { return T() }
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(indexPath: IndexPath, _:T.Type) -> T {
        guard let headerFooterView = self.dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T else { return T() }
        return headerFooterView
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_:T.Type) -> T{
        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T else { return T() }
        return cell
    }
}
