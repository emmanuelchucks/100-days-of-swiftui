//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Emmanuel Chucks on 19/04/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var resortVM = ResortViewModel()
    @StateObject var favorites = Favorites()
    
    @State private var searchText = ""
    @State private var sortOrder = SortOrder.none
    
    @State private var showingSortDialog = false
    
    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .toolbar {
                Button {
                    showingSortDialog.toggle()
                } label: {
                    Label("Sort", systemImage: "arrow.up.arrow.down")
                }
            }
            .confirmationDialog("Sort resorts", isPresented: $showingSortDialog) {
                Button("Default") { sortOrder = .none }
                Button("Alphabetical") { sortOrder = .alphabetical }
                Button("Country") { sortOrder = .country }
            } message: {
                Text("Sort resorts")
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
            
            WelcomeView()
        }
        .environmentObject(favorites)
    }
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return sortedResorts
        } else {
            return sortedResorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var sortedResorts: [Resort] {
        switch sortOrder {
        case .none:
            return resortVM.resorts
        case .alphabetical:
            return resortVM.resorts.sorted { $0.name < $1.name }
        case .country:
            return resortVM.resorts.sorted { $0.country < $1.country }
        }
    }
}

enum SortOrder {
    case none, alphabetical, country
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
