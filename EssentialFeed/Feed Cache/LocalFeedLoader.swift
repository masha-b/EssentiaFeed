//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Maria Biryukova on 17.01.2022.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public typealias SaveResults = Error?
    public init(store: FeedStore, currentDate: @escaping () -> Date = Date.init) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [FeedItem], completion: @escaping (SaveResults) -> ()) {
        store.deleteCacheFeed { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            }
            else {
                self.cache(items, with: completion)
            }
        }
    }
    
    func cache(_ items: [FeedItem], with completion: @escaping (SaveResults) -> ()) {
        store.insert(items.toLocal(), timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}

private extension Array where Element == FeedItem {
    func toLocal() -> [LocalFeedItem] {
        return map { LocalFeedItem(
            id: $0.id,
            description: $0.description,
            location: $0.location,
            imageURL: $0.imageURL
        ) }
    }
}

