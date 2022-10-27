//
//  ContentView.swift
//  Bookworm
//
//  Created by RqwerKnot on 01/03/2022.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [ // an array of SortDescriptors
        SortDescriptor(\.title, order: SortOrder.reverse), // sort by title first, in reverse order
        SortDescriptor(\.author, order: SortOrder.forward) // then, sort by author (in case of 2 books having the same title), in natural order
                                   ]) var books: FetchedResults<Book>
    
    @State private var showAddBookScreen = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(books) { book in
                        NavigationLink {
                            BookDetailsView(book: book)
                        } label: {
                            HStack {
                                EmojiRatingView(rating: book.rating)
                                    .font(.largeTitle)
                                
                                VStack(alignment: .leading) {
                                    Text(book.title ?? "Unknown title (nil)")
                                        .font(.headline)
                                        .foregroundColor(book.rating < 2 ? .primary.opacity(0.2) : .primary)
                                    Text(book.author ?? "Unknown author (nil)")
                                        .foregroundColor(book.rating < 2 ? .secondary.opacity(0.2) : .secondary)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteBooks)
                } header: {
                    Text("\(books.count) books in your library")
                }
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddBookScreen.toggle()
                    } label: {
                        Label("Add book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddBookScreen) {
                AddBookView()
            }
        }
        .onAppear(perform: repairDB)
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let book = books[offset]
            
            // delete it from the context
            moc.delete(book)
        }
        
        // save the context
        try? moc.save()
    }
    
    // for repairing missing Book IDs
    func repairDB() {
        
        for book in books {
            
            guard let id = book.id else {
                print("\(book.title ?? "Unknown title (nil)") book ID is missing. Creating an id...")
                
                book.id = UUID()
                
                if let id = book.id {
                    print("Book: \(book.title ?? "Unknown title (nil)") has now an id: \(id)")
                } else {
                    print("Failed to create an ID for book: \(book.title ?? "Unknown title (nil)")")
                }
                continue // make sure not to exit the 'for' loop altogether, but instead skip to next loop item
            }
            
            print("Book: \(book.title ?? "Unknown title (nil)") has already an id: \(id)")
        }
        
        // saving changes made to the live object into DB:
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var dataController = DataController()
    
    static var previews: some View {
        ContentView()
//            .preferredColorScheme(.dark)
            .previewInterfaceOrientation(.portrait)
            .previewDevice("iPhone 13")
            .environment(\.managedObjectContext, dataController.container.viewContext)
    }
}
