//
// Store.swift
// TextForge
// https://github.com/JPToroDev/TextForge
// See LICENSE for license information.
// © 2023 J.P. Toro
//

import Combine
import StoreKit

typealias Transaction = StoreKit.Transaction

/// A global actor that manages in-app purchases using StoreKit.
final class Store: ObservableObject {
    /// The shared singleton instance for accessing the store.
    static let shared = Store()

    /// Product identifier for the small tip in-app purchase.
    private static let smallTipID = "x.x.TextForge.tip.small"

    /// Product identifier for the medium tip in-app purchase.
    private static let mediumTipID = "x.x.TextForge.tip.medium"

    /// Product identifier for the large tip in-app purchase.
    private static let largeTipID = "x.x.TextForge.tip.large"

    /// All available product identifiers.
    private let productIdentifiers = [smallTipID, mediumTipID, largeTipID]

    /// Currently available in-app purchase products.
    private(set) var products = [Product]()

    /// Products that have been purchased by the customer.
    private(set) var purchasedProducts = [Product]()

    /// Task responsible for monitoring transaction updates.
    private var updateListenerTask: Task<Void, any Error>?

    /// Initializes the store and begins transaction monitoring,
    /// asynchronously loading available products.
    init() {
        setupTransactionListener()

        Task {
            await requestProducts()
            await updateCustomerProductStatus()
        }
    }

    /// Manually initializes the store singleton and begins transaction monitoring.
    ///
    /// - Note: This method should be called early in the app lifecycle to ensure
    /// that the store is set up and ready to monitor transactions from
    /// the App Store. It triggers the lazy initialization of the shared
    /// singleton instance.
    static func initialize() {
        _ = shared
    }

    /// Initiates a purchase for the specified product.
    /// - Parameter product: The product to purchase.
    /// - Returns: The verified transaction if successful, or nil.
    /// - Throws: An error if verification fails.
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updateCustomerProductStatus()
            await transaction.finish()
            return transaction
        default:
            return nil
        }
    }

    /// Checks if a non-consumable product has been purchased.
    /// - Parameter product: The product to check.
    /// - Returns: True if the product has been purchased, false otherwise.
    func isPurchased(_ product: Product) throws -> Bool {
        if product.type == .nonConsumable {
            purchasedProducts.contains(product)
        } else {
            false
        }
    }

    /// Creates a detached task that processes and verifies
    /// incoming transactions from the App Store.
    private func setupTransactionListener() {
        updateListenerTask = Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }

    /// Requests products from the App Store, loading product information
    /// for the specified identifiers and sorting them by price.
    private func requestProducts() async {
        do {
            let products = try await Product.products(for: productIdentifiers)
            let permanentProducts = products.filter { $0.type == .nonConsumable }
            self.products = sortByPrice(permanentProducts)
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }

    /// Verifies a transaction result.
    /// - Parameter result: The verification result to check.
    /// - Returns: The verified value if successful.
    /// - Throws: An error if verification fails.
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            safe
        }
    }

    /// Updates the list of purchased products based on current entitlements, verifying
    /// each transaction and matching it with the corresponding product.
    private func updateCustomerProductStatus() async {
        var purchasedProducts: [Product] = []
        for await result in Transaction.currentEntitlements {
            guard let transaction = try? checkVerified(result),
                  transaction.revocationDate == nil,
                  let product = products.first(where: { $0.id == transaction.productID })
            else { continue }
            purchasedProducts.append(product)
        }

        self.purchasedProducts = purchasedProducts
    }

    /// Sorts products by price from lowest to highest.
    /// - Parameter products: The products to sort.
    /// - Returns: Sorted array of products.
    private func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted(by: { $0.price < $1.price })
    }
}
