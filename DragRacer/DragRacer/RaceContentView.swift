//
//  RaceContentView.swift
//  DragRacer
//
//  Created by Sebastian Bond on 6/23/23.
//

import SwiftUI
import SwiftUILogger

let logger = SwiftUILogger(name: "Demo")

enum Tag: String, LogTagging {
    case information
    case barometer
    
    var value: String { self.rawValue }
}

struct ContentView: View {
    let barometer = Barometer()
    
    enum RaceButtonType: CustomStringConvertible {
        case race
        case abortRace
        
        static prefix func !(operand: RaceButtonType) -> RaceButtonType {
            switch operand {
            case .race:
                return .abortRace
            case .abortRace:
                return .race
            }
        }
        
        var description: String {
            switch self {
            case .race:
                return "Race"
            case .abortRace:
                return "Abort Race"
            }
        }
        
        var image: Image {
            switch self {
            case .race:
                return Image("steeringwheel")
            case .abortRace:
                return Image(systemName: "xmark.circle")
            }
        }
    }
    @State private var raceButtonType = RaceButtonType.race
    
    init() {
        logger.log(level: .info, message: "init")
    }

    func race() {
        logger.log(level: .info, message: raceButtonType.description, tags: [Tag.information])
        raceButtonType = !raceButtonType
    }
    
    func onRaceFinished() {
        // Show stats of the race
        
        
        raceButtonType = .race
    }
    
  var body: some View {
      VStack() {
          LoggerView(logger: logger)
          VStack() {
              Text(
                "asd"
              ).lineLimit(nil)
              Button {
                  race()
              } label: {
                  VStack {
                      raceButtonType.image
                      Text(raceButtonType.description)
                  }
              }
              .buttonStyle(.borderedProminent)
              //        Rectangle()
              //          .foregroundColor(.clear)
              //          .frame(width: 343, height: 56)
              //          .background(Color(red: 0.74, green: 0.11, blue: 0.07))
              //          .cornerRadius(14)
              //          .offset(x: 0, y: 0)
              //        Text("Race")
              //          .font(Font.custom("SF Pro Text", size: 30).weight(.bold))
              //          .lineSpacing(40)
              //          .foregroundColor(.white)
              //          .offset(x: 0, y: 0)
          }
      }
    .onAppear {
        logger.log(level: .info, message: "onAppear", tags: [Tag.information])
        
        Task {
            do {
                for try await data in barometer.getPressure() {
                    logger.log(level: .info, message: String(data), tags: [Tag.barometer])
                }
            } catch let error {
                logger.log(level: .error, message: error.localizedDescription, tags: [Tag.barometer])
            }
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
