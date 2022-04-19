//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Emmanuel Chucks on 12/03/2022.
//

import SwiftUI
import CodeScanner

enum FilterType {
    case none, contacted, uncontacted
}

enum SortOrder {
    case none, name, recent
}

struct ProspectsView: View {
    let filter: FilterType
    var isEveryoneScreen = false
    
    @EnvironmentObject var prospects: Prospects
    @State private var showingScanner = false
    
    @State private var showingSortDialog = false
    @State private var sortOrder = SortOrder.none
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedProspects) { prospect in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(prospect.name)
                                .font(.headline)
                            if isEveryoneScreen == true && prospect.isContacted {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSortDialog = true
                    } label: {
                        Label("Sort prospect", systemImage: "arrow.up.arrow.down")
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingScanner = true
                    } label: {
                        Label("Add prospect", systemImage: "qrcode.viewfinder")
                    }
                }
            }
            .sheet(isPresented: $showingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Emmanuel Chucks\ncontact@emmanuelchucks.com", completion: handleScan)
            }
            .confirmationDialog("Sort prospects", isPresented: $showingSortDialog) {
                Button("Name") { sortOrder = .none }
                Button("Most Recent") { sortOrder = .recent }
            } message: {
                Text("Sort by")
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        showingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let prospect = Prospect()
            prospect.name = details[0]
            prospect.emailAddress = details[1]
            prospects.add(prospect)
        case .failure(let error):
            print("Oops! \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            
            // For production
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            // For testing
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Oops! \(error?.localizedDescription ?? "")")
                    }
                }
            }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    var sortedProspects: [Prospect] {
        switch sortOrder {
        case .none:
            return filteredProspects
        case .name:
            return filteredProspects.sorted()
        case .recent:
            return filteredProspects.reversed()
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
