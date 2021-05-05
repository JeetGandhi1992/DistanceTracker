//
//  CancelBag.swift
//  CoupangPlayDemo
//
//  Created by Jeet Gandhi on 15/3/21.
//

import Combine
import NotificationCenter
import class Foundation.NSLock

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public final class CancelBag: Cancellable {
    
    private let lock: NSLock = NSLock()
    private(set) var cancellables: [AnyCancellable] = []
    
    public init() {
    }
    
    internal func add(_ cancellable: AnyCancellable) {
        self.lock.lock()
        defer { self.lock.unlock() }
        self.cancellables.append(cancellable)
    }
    
    public func cancel() {
        self.lock.lock()
        let cancellables = self.cancellables
        self.cancellables.removeAll()
        self.lock.unlock()
        
        for cancellable in cancellables {
            cancellable.cancel()
        }
    }
    
    public func remove(cancellable: AnyCancellable?) {
        self.lock.lock()
        self.cancellables.removeAll(where: { $0 == cancellable })
        cancellable?.cancel()
        self.lock.unlock()
    }
    
    deinit {
        self.cancel()
    }
}


@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension AnyCancellable {
    
    func cancel(with cancellable: CancelBag) {
        cancellable.add(self)
    }

}

public extension Publisher {
    
    func subscribe(_ receiveValue: @escaping ((Self.Output) -> Void), with cancelBag: CancelBag) {
        var cancellable: AnyCancellable!
        cancellable = self.sink(receiveCompletion: { [weak cancelBag] (event) in
            cancelBag?.remove(cancellable: cancellable)
        },
        receiveValue: receiveValue)
        cancellable?.cancel(with: cancelBag)
    }
}
