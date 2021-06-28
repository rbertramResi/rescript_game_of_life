type counter = {
  mutable count: int
}

let isAlive = (id: int, cellsArr: array<Types.cell>) => {
    let cell = Js.Array.find((c: Types.cell) => c.id == id, cellsArr)
    switch cell {
    | Some(c) => c.state == Types.Alive
    | None => false
  }
}


let numberOfAliveNeighbors = (id: int, cellList: list<Types.cell>, cellsWide: int) => {
  let counter = { count: 0 }
  let cellsArr = cellList -> Belt.List.toArray
  // check clockwise starting at top left neighbor
  // top left
  let topCellLeft = id - cellsWide - 1
  if (topCellLeft -> isAlive(cellsArr)) {
    counter.count = counter.count + 1
  }
  // top 
  let topCell = id - cellsWide
  if (topCell -> isAlive(cellsArr)) {
    counter.count = counter.count + 1
  }
  // top right
  let topCellRight = id - cellsWide + 1
  if (topCellRight -> isAlive(cellsArr)) {
    counter.count = counter.count + 1
  }
  // right
  let rightCell = id + 1
  if (rightCell -> isAlive(cellsArr)) {
    counter.count = counter.count + 1
  }
  // bottom right
  let bottomRightCell = id + cellsWide + 1
  if (bottomRightCell -> isAlive(cellsArr)) {
    counter.count = counter.count + 1
  }
  // bottom
  let bottomCell = id + cellsWide
  if (bottomCell -> isAlive(cellsArr)) {
    counter.count = counter.count + 1
  }
  // bottom left
  let bottomLeftCell = id + cellsWide - 1
  if (bottomLeftCell -> isAlive(cellsArr)) {
    counter.count = counter.count + 1
  }
  // left
  let leftCell = id - 1
  if (leftCell -> isAlive(cellsArr)) {
    counter.count = counter.count + 1
  }
  counter.count
}

let getNewCellState = (cell: Types.cell, neighborCount: int): Types.cellState => {
   if (neighborCount < 2 || neighborCount > 3) {
      Types.Dead
    }
    else if neighborCount == 3 {
      Types.Alive
    } else {
      cell.state
    }
}

let gridTick = (~cellsList: list<Types.cell>, ~cellsWide: int) => {
  let newCellsArr = []
  cellsList -> Belt.List.forEach((cell) => {
    let aliveNeighborsCount = cell.id -> numberOfAliveNeighbors(cellsList, cellsWide)

    // Any live cell with fewer than two live neighbours dies, as if by underpopulation.
    // Any live cell with two or three live neighbours lives on to the next generation.
    // Any live cell with more than three live neighbours dies, as if by overpopulation.
    // Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

    let newCell: Types.cell = {
      id: cell.id,
      state: cell -> getNewCellState(aliveNeighborsCount)
    }
    newCellsArr -> Js.Array2.push(newCell)
  })
  newCellsArr -> Belt.List.fromArray
}
