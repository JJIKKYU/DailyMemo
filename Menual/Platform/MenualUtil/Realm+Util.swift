//
//  Realm+Util.swift
//  Menual
//
//  Created by 정진균 on 2022/12/11.
//

import Foundation
import RealmSwift

extension Results {
    var list: List<Element> {
      reduce(.init()) { list, element in
        list.append(element)
        return list
      }
    }
    
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}