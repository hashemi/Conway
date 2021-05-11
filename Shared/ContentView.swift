//
//  ContentView.swift
//  Shared
//
//  Created by Ahmad Alhashemi on 2021-05-11.
//

import SwiftUI

struct ConwayCanvas: Shape {
  let conway: Conway

  func path(in rect: CGRect) -> Path {
    var path = Path()

    for r in 0..<conway.size {
      for c in 0..<conway.size {
        if conway[r, c] {
          let rect = CGRect(
            x: CGFloat(c) * rect.width / CGFloat(conway.size),
            y: CGFloat(r) * rect.height / CGFloat(conway.size),
            width: rect.width / CGFloat(conway.size),
            height: rect.height / CGFloat(conway.size)
          )
          path.addRect(rect)
        }
      }
    }

    return path
  }
}

struct ContentView: View {
  @State var conway = Conway(size: 96)
  @State var autoPlay = true
  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

  var body: some View {
    VStack {
      ConwayCanvas(conway: conway)
        .fill(Color.blue)
        .aspectRatio(1, contentMode: .fit)
        .background(Color.white)
        .onReceive(timer) { _ in
          if autoPlay {
            conway.nextGeneration()
          }
        }
      
      HStack {
        Toggle("Autoplay", isOn: $autoPlay)
        Button("Next") { conway.nextGeneration() }
      }
      .padding(10)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
      ContentView()
  }
}
