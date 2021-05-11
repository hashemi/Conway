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
  @State var autoPlay = false
  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

  var body: some View {
    VStack {
      GeometryReader { geometry in
        ConwayCanvas(conway: conway)
          .fill(Color.blue)
          .background(Color.white)
          .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onEnded { value in
            let r = Int(value.location.y / geometry.frame(in: .local).height * CGFloat(conway.size))
            let c = Int(value.location.x / geometry.frame(in: .local).width * CGFloat(conway.size))
            conway[r, c].toggle()
          })
      }
      .aspectRatio(1, contentMode: .fit)
      .onReceive(timer) { _ in
        if autoPlay {
          conway.nextGeneration()
        }
      }

      HStack {
        Toggle("Autoplay", isOn: $autoPlay)
        Button("Next") { conway.nextGeneration() }
        Button("Clear") { conway.clear() }
        Button("Randomize") { conway.randomize() }
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
