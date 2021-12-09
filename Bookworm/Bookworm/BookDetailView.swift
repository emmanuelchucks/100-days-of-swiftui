//
//  BookDetailView.swift
//  Bookworm
//
//  Created by Emmanuel Chucks on 08/12/2021.
//

import SwiftUI
import CoreData

struct BookDetailView: View {
    let book: Book
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre ?? "Fantasy")
                    .resizable()
                    .scaledToFit()
                
                Text(book.genre?.uppercased() ?? "FANTASY")
                    .font(.caption.weight(.black))
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            
            Text(book.date?.formatted(date: .abbreviated, time: .shortened) ?? "Unknown Date")
                .font(.caption)
                .padding(.top)
            
            Text(book.author ?? "Unknown Author")
                .font(.title)
                .foregroundColor(.secondary)
                .padding(.top)
            
            Text(book.review ?? "No review")
                .padding()
            
            RatingView(rating: .constant(Int(book.rating)))
                .font(.largeTitle)
        }
        .navigationTitle(book.title ?? "Unknown Title")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: removeBook)
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this book?")
        }
        .toolbar {
            Button {
                showingDeleteAlert = true
            } label: {
                Label("Delete this book", systemImage: "trash")
            }
        }
    }
    
    func removeBook() {
        moc.delete(book)
        try? moc.save()
        dismiss()
    }
}
