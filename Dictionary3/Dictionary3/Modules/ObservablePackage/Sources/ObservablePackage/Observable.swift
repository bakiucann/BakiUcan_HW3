//
//  Observable.swift
//  
//
//  Created by Baki Uçan on 1.06.2023.
//

import Foundation

public class Observable<T> {
    public var value: T? {
        didSet {
            listener?(value)
        }
    }

    public var listener: ((T?) -> Void)?

    public init() {}

    public func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}
