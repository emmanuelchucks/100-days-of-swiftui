//
//  AddBookView.swift
//  Bookworm
//
//  Created by Emmanuel Chucks on 08/12/2021.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
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
                        addBook()
                    }
                }
                .disabled(hasInvalidBookDetails)
            }
            .navigationTitle("Add Book")
        }
    }
    
    func addBook() {
        let newBook = Book(context: moc)
        
        newBook.id = UUID()
        newBook.date = Date.now
        newBook.title = title
        newBook.author = author
        newBook.rating = Int16(rating)
        newBook.genre = genre
        newBook.review = review
        
        try? moc.save()
        dismiss()
    }
    
    var hasInvalidBookDetails: Bool {
        title.trimmed().isEmpty || author.trimmed().isEmpty || genre.trimmed().isEmpty || review.trimmed().isEmpty || rating < 1
    }
}

extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
