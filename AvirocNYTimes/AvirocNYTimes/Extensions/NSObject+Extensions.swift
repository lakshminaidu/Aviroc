//
//  NSObject+Extensions.swift
//  AvirocNYTimes
//
//  Created by Lakshminaidu on 8/4/2022.
//

import Foundation
extension NSObject {
    public static var className: String {
        return String(describing: self.self)
    }
}
