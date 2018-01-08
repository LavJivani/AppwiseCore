//
//  Database+Save.swift
//  AppwiseCore
//
//  Created by David Jennes on 06/03/2017.
//  Copyright © 2016 Appwise. All rights reserved.
//

import CocoaLumberjack
import CoreData
import SugarRecord

extension DB {
	/// Create a new temporary save context. Call `saveToPersistentStore(_:)` with it
	/// when done.
	///
	/// - returns: The new context.
	public func newSave() -> NSManagedObjectContext {
		let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
		
		moc.parent = root
		NotificationCenter.default.addObserver(self, selector: #selector(contextWillSave(notification:)), name: NSNotification.Name.NSManagedObjectContextWillSave, object: moc)
		NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: moc)
		
		return moc
	}

	/// Save the changes in the given context to the persistent store.
	///
	/// - parameter moc: The managed object context.
	public func saveToPersistentStore(_ moc: NSManagedObjectContext) throws {
		guard let parent = moc.parent, parent == root else {
			throw DBError.invalidContext
		}
		
		try moc.save()
		
		var _error: Error?
		parent.performAndWait {
			do {
				try parent.save()
			} catch {
				_error = error
			}
		}
		
		if let error = _error {
			throw error
		}
	}
	
	@objc private func contextWillSave(notification: Notification) {
		guard let moc = notification.object as? NSManagedObjectContext else { return }
		_ = try? moc.obtainPermanentIDs(for: Array(moc.insertedObjects))
	}
	
	@objc private func contextDidSave(notification: Notification) {
		guard let main = db?.mainContext as? NSManagedObjectContext else { return }
		main.mergeChanges(fromContextDidSave: notification as Notification)
	}
}
