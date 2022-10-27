//
//  HogwartsContentView.swift
//  Bookworm
//
//  Created by RqwerKnot on 01/03/2022.
//

import SwiftUI

struct HogwartsContentView: View {
    
    // Student entity from Hogwarts data model is a Managed Obeject: it's being managed by CoreData:
    // loading from the persistent container and writing changes back too
    // All managed objects live inside a managed object context. We placed it into the SwiftUI environment from the app file 'BookwormApp' with .environment() modifier
    // it is automatically used for the @FetchRequest property wrapper – it uses whatever managed object context is available in the environment:
    @FetchRequest(sortDescriptors: []) var hogwartsStudents: FetchedResults<Student>
    
    // However, when it comes to adding and saving objects, we need access to the managed object context that it is in SwiftUI’s environment. This is another use for the @Environment property wrapper – we can ask it for the current managed object context, and assign it to a property for our use.
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            List(hogwartsStudents) { student in

                Text(student.name ?? "Unknown")

                // even if we define Student's attribute 'name' as non-optional, CoreData will still generate optional Swift properties when reading properties
                // because, when defined as non-optional in CoreData Model Editor, all Core Data cares about is that the properties have values when they are saved – they can be nil at other times.
                // this is a different concept of 'optionals' than Swift's
            }
            
            Button("Add a student") {
                let names = ["ginnie", "harry", "hermione", "ron", "luna"]
                let surnames = ["potter", "weasley", "granger", "goodwill"]
                
                let name = "\(names.randomElement()!) \(surnames.randomElement()!)"
                
                let student = Student(context: moc)
                student.name = name
                student.id = UUID()
                
                try? moc.save()
            }
        }
    }
}

struct HogwartsContentView_Previews: PreviewProvider {
    
    static var hogwartsDataController = HogwartsDataController()
    
    static var previews: some View {
        
        HogwartsContentView()
            .environment(\.managedObjectContext, hogwartsDataController.container.viewContext)
    }
}
