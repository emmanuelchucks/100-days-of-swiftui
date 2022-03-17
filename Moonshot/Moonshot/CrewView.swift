//
//  CrewView.swift
//  Moonshot
//
//  Created by Emmanuel Chucks on 06/12/2021.
//

import SwiftUI

struct CrewView: View {
    let crew: [CrewMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink {
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .overlay(
                                    Circle()
                                        .stroke(.lightBackground, lineWidth: 4)
                                )
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("\(crewMember.role) \(crewMember.role == "Command Pilot" || crewMember.role == "Commander" ? "🏅" : "")")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .padding(.trailing)
        }
    }
}

struct CrewMember {
    let astronaut: Astronaut
    let role: String
}

struct CrewView_Previews: PreviewProvider {
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    
    static let crew: [CrewMember] = missions[1].crew.map { member in
        if let astronaut = astronauts[member.name] {
            return CrewMember(astronaut: astronaut, role: member.role)
        } else {
            fatalError("Missing \(member.name)")
        }
    }
    
    static var previews: some View {
        CrewView(crew: crew)
            .preferredColorScheme(.dark)
    }
}
