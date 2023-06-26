//
//  SavesListContentView.swift
//  DragRacer
//
//  Created by Sebastian Bond on 6/26/23.
//

import SwiftUI

struct SavesListContentView: View {
    let saves: [Save]
    
    var sections: [String] {
        Array(Set(saves.map { $0.section }))
            .sorted()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(sections, id: \.self) { section in
                    Section(header: Text(section)) {
                        ForEach(saves.filter { $0.section == section }) { save in
                            NavigationLink(destination: SaveContentView(save: save)) {
                                VStack {
                                    Text(save.dateDescription).font(Font.headline)
                                    Text(save.vehicleName)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SavesListContentViewPreviews: PreviewProvider {
  static var previews: some View {
      SavesListContentView(saves: [Save.example])
  }
}
