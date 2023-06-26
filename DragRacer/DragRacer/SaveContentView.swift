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
    func textRow(systemImage: String, _ contents: String, secondaryContents: String? = nil, tertiarySystemImages: [String?] = [], tertiaryContents: [String?] = []) -> some View {
        let paddingExtra: CGFloat = 12
        let spacingExtra: CGFloat = 3
        VStack(alignment: .leading, spacing: spacingExtra) {
            Label(contents, systemImage: systemImage)
                .foregroundColor(.primary)
                .font(.headline)
            
            if let secondaryContents = secondaryContents {
                HStack(spacing: spacingExtra) {
                    Text(secondaryContents)
                        .padding(.leading)
                        .padding(.leading)
                        .padding(.leading, paddingExtra)
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
            }
            
            // https://stackoverflow.com/questions/60043204/iterating-over-multiple-arrays-with-foreach-swiftui
            ForEach(Array(zip(tertiarySystemImages, tertiaryContents)), id: \.0) { (tertiarySystemImage, tertiaryContents) in
                if let systemImage = tertiarySystemImage, let contents = tertiaryContents {
                    Label(contents, systemImage: systemImage)
                        //.foregroundColor(.primary)
                        //.font(.headline)
                }
                else if let contents = tertiaryContents {
                    HStack(spacing: spacingExtra) {
                        Text(contents)
                            .padding(.leading)
                            .padding(.leading)
                            .padding(.leading, paddingExtra)
                    }
                }
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
        }
    }
    
    @ViewBuilder
    func textRowHorizontal(_ annotation: String, _ contents: String) -> some View {
        // https://developer.apple.com/documentation/swiftui/displaying-data-in-lists
        HStack(spacing: 0) {
            HStack(spacing: 3) {
                Text(annotation)
            }
            .foregroundColor(.secondary)
            .font(.subheadline)
            Spacer()
            Text(contents)
                .foregroundColor(.primary)
                .font(.headline)
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
//            Text(save.locationDescription)
//                .font(.body)
            List {
                textRow("Driver", save.driverName)
                textRow("Vehicle", save.vehicleName)
                Section {
                    textRow(systemImage: "location.square", save.locationDescription, secondaryContents: save.latitudeLongitudeDescription) // Location; latitude and longitude
                    let icon: String? = getSystemImageIcon(save.forecastSky)
                    let forecastSky: String? = icon == nil ? save.forecastSky : nil
                    textRow(systemImage: icon ?? "thermometer.medium", save.forecastTemperatureDescription, secondaryContents: forecastSky, tertiarySystemImages: ["humidity", nil], tertiaryContents: [save.humidityDescription, save.atmosphericPressureDescription]) // Temperature and sky conditions
                } header: {
                    Text("Location Details")
                }
                
                Section {
                    textRowHorizontal("R/T", save.reactionTimeDescription) // Reaction time
                    //textRow(systemImage: "stopwatch", save._0to60TimeDescription) // 0-60 time
                    textRowHorizontal("0-60 time", save._0to60TimeDescription) // 0-60 time
                    textRowHorizontal("330 ft time", save._330ftTimeDescription) // 330 ft time
                    textRowHorizontal("1/8 mi time", save.eighthMileTimeDescription) // 1/8 mi time
                    textRowHorizontal("1/8 mi speed", save.eighthMileSpeedDescription) // 1/8 mi speed
                    textRowHorizontal("1000 ft time", save._1000ftTimeDescription) // 1000 ft time
                    textRowHorizontal("1/4 mi time", save.quarterMileTimeDescription) // 1/4 mi time
                    textRowHorizontal("1/4 mi speed", save.quarterMileSpeedDescription) // 1/4 mi speed
                } header: {
                    Text("Race Details")
                }//.listStyle(.plain)
                .listRowSeparator(.hidden)
                .listSectionSeparator(.visible)
            }//.scrollContentBackground(.hidden)
            // https://sarunw.com/posts/swiftui-list-style/
            .listStyle(.inset)
            
            Spacer()
        }
        .environment(\.defaultMinListRowHeight, 30) //minimum row height
        .navigationBarTitle(Text("Save Details"))
    }
}

struct SaveContentViewPreviews: PreviewProvider {
  static var previews: some View {
      SaveContentView(save: Save.example)
  }
}
