//
//  UICollectionViewExtension.swift
//  Rocket.Chat
//
//  Created by Elen on 24/12/2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import Foundation

public extension UICollectionView{
    
    
    func register<T: UICollectionViewCell>(_: T.Type){
        self.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    
    func registerNib<T: UICollectionViewCell>(_: T.Type){
        let nib = UINib(nibName: String(describing: T.self), bundle: Bundle(for: T.self))
        self.register(nib, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    
    func registerNib<T:UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind kind: String){
        let nib = UINib(nibName: String(describing: T.self), bundle: Bundle(for: T.self))
        self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: T.self))
    }
    
    
    func register<T:UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind kind: String){
        self.register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: T.self))
    }
    
    
    
    func dequeueReusableCell<T: UICollectionViewCell>(_: T.Type,indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else { return T() }
        return cell
        
    }
    
    
    
    func dequeueReusableHeaderFooterView<T: UICollectionReusableView>(_: T.Type,ofKind:String,indexPath: IndexPath) -> T{
        guard let view = self.dequeueReusableSupplementaryView(ofKind: ofKind, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else{ return T()}
        return view
    }
    
}
