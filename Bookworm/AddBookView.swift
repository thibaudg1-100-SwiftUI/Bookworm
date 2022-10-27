//
//  AddBookView.swift
//  Bookworm
//
//  Created by RqwerKnot on 01/03/2022.
//

import SwiftUI

struct AddBookView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var review = ""
    @State private var rating = 3
    @State private var genre = ""
    
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                
                Section {
                    Button("Save") {
                        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                            alertMessage = "Please enter a valid title"
                            showAlert.toggle()
                            return
                        }
                        
                        guard !author.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                            alertMessage = "Please enter a valid author"
                            showAlert.toggle()
                            return
                        }
                        
                        guard !genre.isEmpty else {
                            alertMessage = "Please choose a genre"
                            showAlert.toggle()
                            return
                        }
                        // create a new Book entity within a specific CoreData Managed Object Context
                        let newBook = Book(context: moc)
                        // assign values to each entity's attributes:
                        newBook.id = UUID()
                        newBook.title = self.title
                        newBook.author = self.author
                        newBook.genre = self.genre
                        newBook.review = self.review
                        newBook.rating = Int16(self.rating)
                        newBook.date = Date.now
                        // save persistently the Managed Object Context:
                        try? moc.save()
                        // dismiss SwiftUI sheet:
                        dismiss()
                    }
                    
                }
            }
            .navigationTitle("Add Book")
            .alert("Oups 🤭", isPresented: $showAlert) {
                // No need for a "OK" Button; SwiftUI adds it automatically when no other Button is declared here
            } message: {
                Text(alertMessage)
            }
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
