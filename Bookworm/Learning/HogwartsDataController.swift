//
//  HogwartsDataController.swift
//  Bookworm
//
//  Created by RqwerKnot on 01/03/2022.
//

// import CoreData to work with CoreData framework:
import CoreData
import Foundation

class HogwartsDataController: ObservableObject {
    // NSPersistentContainer is the Core Data type responsible for loading a data model and giving us access to the data inside
    
    // That tells Core Data we want to use the Hogwarts data model:
    let container = NSPersistentContainer(name: "Hogwarts")
    
    // data models store definitions of the entities and attributes we want to use
    
    // To actually load the data model we need to call loadPersistentStores() on our container, which tells Core Data to access our saved data according to the data model in Hogwarts.xcdatamodeld
    // This doesn’t load all the data into memory at the same time, because that would be wasteful, but at least Core Data can see all the information we have.
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("DataController failed to load data from persistent Stores: \(error.localizedDescription)")
            }
            print("NSPersitentStoreDescription: \(description.type)")
        }
    }
}
