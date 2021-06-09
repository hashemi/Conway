//
//  Conway.swift
//  Conway
//
//  Created by Ahmad Alhashemi on 2021-05-11.
//

struct Conway {
  private struct Cell {
    private var data: UInt8
    
    init() { self.data = 0 }

    var alive: Bool {
      get { data & 1 == 1 }
      set { if newValue { data |= 1} else { data &= ~1 } }
    }
    
    var isBlank: Bool { data == 0 }

    var neighbours: UInt8 { data >> 1 }
    mutating func increment() { data += 0b10 }
    mutating func decrement() { data -= 0b10 }
    
    mutating func clear() { data = 0 }
  }
  
  private var grid: [Cell]
  let size: Int
  
  subscript(row: Int, col: Int) -> Bool {
    get { grid[row * size + col].alive }
    set {
      func updateNeighbours(row: Int, col: Int, action: (inout Cell) -> ()) {
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
        grid[row * size + col].alive = true
        updateNeighbours(row: row, col: col) { $0.increment() }
      } else {
        grid[row * size + col].alive = false
        updateNeighbours(row: row, col: col) { $0.decrement() }
      }
    }
  }
  
  mutating func nextGeneration() {
    let original = grid
    
    for r in 0..<size {
      for c in 0..<size {
        let cell = original[r * size + c]
        guard !cell.isBlank else { continue }
        
        switch cell.neighbours {
        case 3: self[r, c] = true  // lives
        case 2: break              // doesn't change
        case _: self[r, c] = false // dies
        }
      }
    }
  }
  
  mutating func clear() {
    for i in grid.indices { grid[i].clear() }
  }
  
  mutating func randomize() {
    for r in 0..<size {
      for c in 0..<size {
        if Bool.random() {
          self[r, c] = true
        }
      }
    }
  }
  
  init(size: Int) {
    self.size = size
    self.grid = Array(repeating: .init(), count: size * size)
  }
}
