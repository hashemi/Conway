//
//  Conway.swift
//  Conway
//
//  Created by Ahmad Alhashemi on 2021-05-11.
//

struct Conway {
  private var grid: [UInt8]
  let size: Int
  
  subscript(row: Int, col: Int) -> Bool {
    get { grid[row * size + col] & 1 == 1 }
    set {
      if newValue {
        grid[row * size + col] |= 1
      } else {
        grid[row * size + col] &= ~1
      }
    }
  }
  
  mutating func nextGeneration() {
    for _ in 0..<size {
      self[(0..<size).randomElement()!, (0..<size).randomElement()!] = Bool.random()
    }
  }
  
  init(size: Int) {
    self.size = size
    self.grid = Array(repeating: 0, count: size * size)
  }
}
