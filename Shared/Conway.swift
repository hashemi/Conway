//
//  Conway.swift
//  Conway
//
//  Created by Ahmad Alhashemi on 2021-05-11.
//

struct Conway {
  private var grid: [Bool]
  let size: Int
  
  subscript(row: Int, col: Int) -> Bool {
    get { grid[row * size + col] }
    set { grid[row * size + col] = newValue }
  }
  
  mutating func nextGeneration() {
    for _ in 0..<size {
      self[(0..<size).randomElement()!, (0..<size).randomElement()!] = Bool.random()
    }
  }
  
  init(size: Int) {
    self.size = size
    self.grid = Array(repeating: false, count: size * size)
  }
}
