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
    case activity
    case analysis
    case information
    case web
    case home
    
    var value: String { self.rawValue }
}

struct ContentView: View {
    init() {
        logger.log(level: .info, message: "init")
    }

  var body: some View {
      VStack() {
          LoggerView(logger: logger)
          VStack() {
              Text(
                "asd"
              ).lineLimit(nil)
              Button {
                  logger.log(level: .info, message: "Race pressed")
                  //race()
                  
                  logger.log(
                                  level: .info,
                                  message: "onAppear",
                                  tags: [Tag.home, .information, .web]
                              )
              } label: {
                  VStack {
                      Image("steeringwheel")
                      Text("Race")
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
        logger.log(level: .info, message: "onAppear")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
