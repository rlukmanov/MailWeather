//
//  CoreDataStack.swift
//  MailWeather
//
//  Created by Ruslan Lukmanov on 24.11.2020.
//

import Foundation
import CoreData

class CoreDataStack {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.NameProject)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
