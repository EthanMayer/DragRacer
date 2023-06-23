//
//  RaceContentView.swift
//  DragRacer
//
//  Created by Sebastian Bond on 6/23/23.
//

import SwiftUI
import SwiftUILogger

let logger = SwiftUILogger(name: "Demo")

struct ContentView: View {
    init() {
        logger.log(level: .info, message: "init")
    }

  var body: some View {
    ZStack() {
        LoggerView(logger: logger)
      ZStack() {
        Text("9:41")
          .font(Font.custom("SF Pro Text", size: 15).weight(.semibold))
          .foregroundColor(.white)
          .offset(x: -147.50, y: 2)
        ZStack() {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 22, height: 11.33)
            .cornerRadius(2.67)
            .overlay(
              RoundedRectangle(cornerRadius: 2.67)
                .inset(by: 0.50)
                .stroke(.black, lineWidth: 0.50)
            )
            .offset(x: -1.16, y: 0)
            .opacity(0.35)
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 18, height: 7.33)
            .background(.white)
            .cornerRadius(1.33)
            .offset(x: -1.16, y: 0)
        }
        .frame(width: 24.33, height: 11.33)
        .offset(x: 161, y: 1)
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 15.33, height: 11)
          .background(
            AsyncImage(url: URL(string: "https://via.placeholder.com/15x11"))
          )
          .offset(x: 136.17, y: 0.83)
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 17, height: 10.67)
          .background(
            AsyncImage(url: URL(string: "https://via.placeholder.com/17x11"))
          )
          .offset(x: 115, y: 1)
      }
      .frame(width: 375, height: 44)
      .offset(x: 6, y: -384)
      VStack() {
          Text(
              "asd"
          ).lineLimit(nil)
          Button {
              print("Race pressed")
              //race()
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
      .frame(width: 343, height: 56)
      .offset(x: -3, y: 262)
      Rectangle()
        .foregroundColor(.clear)
        .frame(width: 382, height: 270)
        .background(
          AsyncImage(url: URL(string: "https://via.placeholder.com/382x270"))
        )
        .cornerRadius(42)
        .offset(x: -2.50, y: -26)
        .shadow(
          color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
        )
      Rectangle()
        .foregroundColor(.clear)
        .frame(width: 258, height: 588)
        .background(
          AsyncImage(url: URL(string: "https://via.placeholder.com/258x588"))
        )
        .offset(x: -3.50, y: -68)
      ZStack() {
        VStack(spacing: 2) {
          HStack(spacing: 0) {
            Text("􀉟")
              .font(Font.custom("SF Pro Display", size: 20))
              .tracking(0.38)
              .lineSpacing(24)
              .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.40))
          }
          .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 4))
          .frame(maxWidth: .infinity, minHeight: 28, maxHeight: 28)
          Text("Options")
            .font(Font.custom("SF Pro Text", size: 12).weight(.bold))
            .tracking(0.16)
            .lineSpacing(12)
            .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.58))
        }
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 2, trailing: 0))
        .frame(height: 49)
        .offset(x: 141, y: -17)
        VStack(spacing: 2) {
          HStack(spacing: 0) {
            Text("􀉬")
              .font(Font.custom("SF Pro Display", size: 20))
              .tracking(0.38)
              .lineSpacing(24)
              .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.40))
          }
          .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
          .frame(maxWidth: .infinity, minHeight: 28, maxHeight: 28)
          Text("Vehicles")
            .font(Font.custom("SF Pro Text", size: 12).weight(.bold))
            .tracking(0.16)
            .lineSpacing(12)
            .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.58))
        }
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 2, trailing: 0))
        .frame(height: 49)
        .offset(x: 47, y: -17)
        VStack(spacing: 2) {
          HStack(spacing: 0) {
            Text("􀌥")
              .font(Font.custom("SF Pro Display", size: 20))
              .tracking(0.38)
              .lineSpacing(24)
              .foregroundColor(Color(red: 0.39, green: 0.39, blue: 0.40))
          }
          .padding(2)
          .frame(maxWidth: .infinity, minHeight: 28, maxHeight: 28)
          Text("Saves")
            .font(Font.custom("SF Pro Text", size: 12).weight(.bold))
            .tracking(0.16)
            .lineSpacing(12)
            .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.58))
        }
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 2, trailing: 0))
        .frame(height: 49)
        .offset(x: -47, y: -17)
        VStack(alignment: .leading, spacing: 2) {
          HStack(spacing: 0) {
            Text("􀎟")
              .font(Font.custom("SF Pro Display", size: 20))
              .tracking(0.38)
              .lineSpacing(24)
              .foregroundColor(Color(red: 0.92, green: 0.34, blue: 0.34))
          }
          .padding(EdgeInsets(top: 2, leading: 1, bottom: 2, trailing: 1))
          .frame(maxWidth: .infinity, minHeight: 28, maxHeight: 28)
          Text("Race")
            .font(Font.custom("SF Pro Text", size: 12).weight(.bold))
            .tracking(0.16)
            .lineSpacing(12)
            .foregroundColor(Color(red: 0.92, green: 0.34, blue: 0.34))
        }
        .padding(EdgeInsets(top: 5, leading: 32, bottom: 2, trailing: 30))
        .frame(height: 49)
        .offset(x: -141, y: -17)
      }
      .frame(width: 375, height: 83)
      .offset(x: -3, y: 364.50)
      HStack(spacing: 0) {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 134, height: 5)
          .background(.white)
          .cornerRadius(100)
      }
      .padding(EdgeInsets(top: 21, leading: 121, bottom: 8, trailing: 120))
      .frame(width: 375, height: 34)
      .offset(x: 0, y: 389)
    }
    .frame(width: 375, height: 812)
    .cornerRadius(40)
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
