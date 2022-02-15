//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Maria Biryukova on 17.01.2022.
//

import Foundation

public enum RetrieveCachedFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> ()
    typealias InsertionCompletion = (Error?) -> ()
    typealias RetrievalCompletion = (RetrieveCachedFeedResult) -> ()
    
    func deleteCacheFeed(completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}

