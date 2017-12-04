//
//  AppDelegate.swift
//  AppwiseCore
//
//  Created by David Jennes on 17/09/16.
//  Copyright © 2016 Appwise. All rights reserved.
//

import UIKit

public protocol ApplicationService: UIApplicationDelegate {}

public extension ApplicationService {
	public var window: UIWindow? {
		return UIApplication.shared.delegate?.window ?? nil
	}
}

extension Array where Element == ApplicationService {
	@discardableResult
	func apply<T, S>(_ work: (ApplicationService, @escaping (T) -> Void) -> S?, completionHandler: @escaping ([T]) -> Swift.Void) -> [S] {
		let dispatchGroup = DispatchGroup()
		var results: [T] = []
		var returns: [S] = []

		for service in self {
			dispatchGroup.enter()
			let returned = work(service, { result in
				results.append(result)
				dispatchGroup.leave()
			})
			if let returned = returned {
				returns.append(returned)
			} else { // delegate doesn't impliment method
				dispatchGroup.leave()
			}
			if returned == nil {
			}
		}

		dispatchGroup.notify(queue: .main) {
			completionHandler(results)
		}

		return returns
	}
}
