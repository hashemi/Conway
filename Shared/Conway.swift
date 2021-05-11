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
      func updateNeighbours(row: Int, col: Int, action: (inout UInt8) -> ()) {
        func wrap(_ i: Int) -> Int { (i + size) % size }
        
        action(&grid[wrap(row - 1) * size + wrap(col - 1)])
        action(&grid[wrap(row - 1) * size + col])
        action(&grid[wrap(row - 1) * size + wrap(col + 1)])

        action(&grid[row * size + wrap(col - 1)])
        action(&grid[row * size + wrap(col + 1)])

        action(&grid[wrap(row + 1) * size + wrap(col - 1)])
        action(&grid[wrap(row + 1) * size + col])
        action(&grid[wrap(row + 1) * size + wrap(col + 1)])
      }
      
      guard newValue != self[row, col] else { return }
      
      if newValue {
        grid[row * size + col] |= 1
        updateNeighbours(row: row, col: col) { $0 += 0b10 }
      } else {
        grid[row * size + col] &= ~1
        updateNeighbours(row: row, col: col) { $0 -= 0b10 }
      }
    }
  }
  
  mutating func nextGeneration() {
    let original = grid
    
    for r in 0..<size {
      for c in 0..<size {
        let cell = original[r * size + c]
        guard cell != 0 else { continue }
        
        switch (cell >> 1) {
        case 3: self[r, c] = true  // lives
        case 2: break              // doesn't change
        case _: self[r, c] = false // dies
        }
      }
    }
  }
  
  init(size: Int) {
    self.size = size
    self.grid = Array(repeating: 0, count: size * size)
    
    // random start
    for r in 0..<size {
      for c in 0..<size {
        if Bool.random() {
          self[r, c] = true
        }
      }
    }
  }
}
