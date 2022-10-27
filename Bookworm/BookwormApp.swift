//
//  BookwormApp.swift
//  Bookworm
//
//  Created by RqwerKnot on 01/03/2022.
//

import SwiftUI

@main
struct BookwormApp: App {
    
    // creates a data controller at app's root
    @StateObject private var hogwartsDataController = HogwartsDataController()
    
    // creates a data controller at app's root
    @StateObject private var dataController = DataController()
    
    let learning = false
    
    var body: some Scene {
        WindowGroup {
            if learning {
                HogwartsContentView()
                    .environment(\.managedObjectContext, hogwartsDataController.container.viewContext)
                // place the data controller view Context into SwiftUI environment through main app struct
                // Managed Object Context are effectively the “live” version of your data – when you load objects and change them, those changes only exist in memory (RAM) until you specifically save them back to the persistent store (ie. iPhone SSD).
            } else {
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
            }
        }
    }
}
