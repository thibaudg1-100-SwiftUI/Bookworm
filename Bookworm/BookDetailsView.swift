//
//  BookDetailsView.swift
//  Bookworm
//
//  Created by RqwerKnot on 03/03/2022.
//

import SwiftUI


struct BookDetailsView: View {
    
    let book: Book
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    private var date: String {
        guard let date = self.book.date else {
            return "Added in the past"
        }
        
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .numeric
        formatter.unitsStyle = .full
        
        guard let string = formatter.string(for: date) else {
            let dateString = "Added on: " + date.formatted(date: .long, time: .omitted)
            return dateString
        }
        
        return "Added: \(string)"
    } // format nicely the date the book was added
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Fantasy")
                    .resizable()
                    .scaledToFit()
                
                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            
            Text(book.author ?? "Unknown author")
                .font(.title)
                .foregroundColor(.secondary)

            Text(book.review ?? "No review")
                .padding()
            
            // We don't want here a two-way flow of data for the RatingView so we pass a constant Binding
            // Also we can scale up the View using .font modifier because the View uses SF symbols that scale seamlessly by default
            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
            
            Text(date)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(5)
            
        }
        .navigationTitle(book.title ?? "Unknown Book")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
//            Button("Cancel", role: .cancel) { } // No need to add this Button because SwiftUi will do it automatically when there is already a destructive action/Button delcared
            // Only useful when you need to override the automatic Cancel button with a specific label or a non-void action closure
        } message: {
            Text("Are you sure?")
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
    }
    
    func deleteBook() {
        moc.delete(book)
        // uncomment this line if you want to make the deletion permanent:
        // try? moc.save()
        
//        dismiss() // dismiss the current Navigation stack = going back to ContentView in this case
        // not mandatory because SwiftUI will automatically "back-stack" to ContentView since the current object (book) is no more and then can't be displayed
    }
}

// the following code doesn't work:
// let's not use the preview at all for this screen

//import CoreData
//
//struct DetailView_Previews: PreviewProvider {
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//
//    static var previews: some View {
//        let book = Book(context: moc)
//        book.title = "Test book"
//        book.author = "Test author"
//        book.genre = "Fantasy"
//        book.rating = 4
//        book.review = "This was a great book; I really enjoyed it."
//
//        return NavigationView {
//            BookDetailsView(book: book)
//        }
//    }
//}
