// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import SwiftUI
import Kingfisher

protocol ImageLoaderProtocol {
    func loadImage(url: URL) async throws -> Image
}

public protocol ImageCacheProtocol {
    func retrieveImage(forKey key: String) async throws -> KFCrossPlatformImage?
    func store(_ image: KFCrossPlatformImage, forKey key: String)
}

public class DefaultImageCache: ImageCacheProtocol {
    private let cache: ImageCache

    public init(cache: ImageCache = .default) {
        self.cache = cache
    }

    public func retrieveImage(forKey key: String) -> KFCrossPlatformImage? {
        return cache.retrieveImageInMemoryCache(forKey: key)
    }

    public func store(_ image: KFCrossPlatformImage, forKey key: String) {
        cache.store(image, forKey: key)
    }
}

public class DefaultImageLoader: ImageLoaderProtocol {
    public let kfManager: KingfisherManager
    public let imageCache: ImageCacheProtocol

    public init(kfManager: KingfisherManager = .shared, imageCache: ImageCacheProtocol = DefaultImageCache()) {
        self.kfManager = kfManager
        self.imageCache = imageCache
    }
    
    public func loadImage(url: URL) async throws -> Image {
        if let cachedImage = try? await imageCache.retrieveImage(forKey: url.absoluteString) {
            return Image(uiImage: cachedImage)
        }

        return try await withCheckedThrowingContinuation { continuation in
            let task = Task {
                kfManager.retrieveImage(with: url) {[weak self] result in
                    switch result {
                    case .success(let value):
                        self?.imageCache.store(value.image, forKey: url.absoluteString)
                        continuation.resume(returning: Image(uiImage: value.image))
                    case .failure(let error):
                        print("Error loading image: \(error)")
                        continuation.resume(returning: Image(systemName: "photo.fill"))
                    }
                }
            }

            Task {
                await withTaskCancellationHandler {
                    task.cancel()
                } onCancel: {
                    print("Task canceled")
                }
            }
        }
    }
}
