//
//  SaveContentView.swift
//  DragRacer
//
//  Created by Sebastian Bond on 6/26/23.
//

import SwiftUI

struct SaveContentView: View {
    let save: Save
    
    // @ViewBuilder makes this function able to return a SwiftUI View instance ( https://developer.apple.com/forums/thread/652844 )
    @ViewBuilder
    func textRow(_ annotation: String, _ contents: String) -> some View {
//        HStack {
//            Text(annotation)
//            Spacer()
//            Text(contents).foregroundColor(.secondary)
//        }
        
        // https://developer.apple.com/documentation/swiftui/displaying-data-in-lists
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 3) {
                Text(annotation)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            Text(contents)
                .foregroundColor(.primary)
                .font(.headline)
        }
    }
    @ViewBuilder
    func textRow(_ contents: String) -> some View {
        Text(contents)
    }
    @ViewBuilder
    func textRow(systemImage: String, _ contents: String, secondaryContents: String?) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Label(contents, systemImage: systemImage)
                .foregroundColor(.primary)
                .font(.headline)
            
            if let secondaryContents = secondaryContents {
                HStack(spacing: 3) {
                    Text(secondaryContents)
                        .padding(.leading)
                        .padding(.leading)
                        .padding(.leading)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
        }
    }
    
    func getSystemImageIcon(_ forecastSky: String) -> String? {
        switch forecastSky {
        case "Cloudy": // fill in with weather api things, todo
            return "cloud"
        default:
            return nil
            // etc. todo
        }
    }
        
    var body: some View {
        VStack(spacing: 0) {
            Text("Drag Racer")
                .font(.largeTitle)
                .padding(.top)
            Text("All the magic, under the hood")
                .font(.title2)
            Text(save.dayDateDescription)
                .font(.body)
                .padding(.top)
            Text(save.timeDescription)
                .font(.body)
            Text(save.locationDescription)
                .font(.body)
            List {
                textRow("Driver", save.driverName)
                textRow("Vehicle", save.vehicleName)
                Section {
                    textRow(systemImage: "location.square.fill", save.locationDescription, secondaryContents: save.latitudeLongitudeDescription) // Location; latitude and longitude
                    let icon: String? = getSystemImageIcon(save.forecastSky)
                    let forecastSky: String? = icon == nil ? save.forecastSky : nil
                    textRow(systemImage: icon ?? "thermometer.medium", save.forecastTemperatureDescription, secondaryContents: forecastSky) // Temperature and sky conditions
                } header: {
                    Text("Location Details")
                }
            }//.scrollContentBackground(.hidden)
            // https://sarunw.com/posts/swiftui-list-style/
            .listStyle(.inset)
            
            Spacer()
        }
        .navigationBarTitle(Text("Save Details"))
    }
}

struct SaveContentViewPreviews: PreviewProvider {
  static var previews: some View {
      SaveContentView(save: Save.example)
  }
}
