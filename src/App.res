%%raw("require('./App.css')")
// GOL rules
// Any live cell with fewer than two live neighbours dies, as if by underpopulation.
// Any live cell with two or three live neighbours lives on to the next generation.
// Any live cell with more than three live neighbours dies, as if by overpopulation.
// Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

// grid with timer updating cells at steady cadence each iteration updates each cell according to the four above rules

let cellWidth = 12
@react.component
let make = () => {
  let intervalId: React.ref<option<Js_global.intervalId>> = React.useRef(None)
  let cellsRef: React.ref<list<Types.cell>> = React.useRef(list{})

  let (cells, setCells) = React.useState(_ => list{})
  let (cellsHigh, _) = React.useState(_ => 40)
  let (cellsWide, _) = React.useState(_ => 40)
  let totalCells = cellsHigh * cellsWide

  let gridWidth = (cellsWide * cellWidth + cellsWide + 1) -> Belt.Int.toString ++ "px"
  let cellWidthPx = cellWidth -> Belt.Int.toString ++ "px"


  React.useEffect0(() => {
    let initialCells: list<Types.cell> = totalCells -> Belt.List.makeBy(i => {
      Types.state: Types.Dead,
      Types.id: i,
    })
    setCells(_ => initialCells)
    None
  })

  // necessary so we can reference updated values in interval
  React.useEffect1(() => {
    cellsRef.current = cells;
    None
  }, [cells])

  let start = () => {
    if cells -> Belt.List.length == 0 {
      ()
    }

    switch intervalId.current {
      | Some(id) => Js.Global.clearInterval(id)
      | None => ()
    }

    intervalId.current = Js.Global.setInterval(() => {
      setCells(_ => Helpers.gridTick(
        ~cellsList=cellsRef.current,
        ~cellsWide=cellsWide
      ))
    },
    100) -> Some
  }

  let getCellClassNameByState = (state: Types.cellState) => {
    switch state {
      | Alive => "cell-alive"
      | Dead => "cell-dead"
    }
  }

  let computeToggleCellState = (cell: Types.cell, toggleId: int) => {
    if cell.id != toggleId {
      cell.state
    } else if cell.state == Types.Alive {
      Types.Dead
    } else {
      Types.Alive
    }
  }

  let toggleCell = (cell: Types.cell) => {
    let cellsArr = cells
      -> Belt.List.toArray
      -> Belt.Array.map((c) => {
          Types.id: c.id,
          Types.state: c -> computeToggleCellState(cell.id),
        })
    setCells(_ => cellsArr -> Belt.List.fromArray)
  }
  
  let randomize = () => {
    let randomizedCells: list<Types.cell> = totalCells -> Belt.List.makeBy(i => {
      Types.state: Js.Math.random() > 0.75 ? Types.Alive : Types.Dead,
      Types.id: i,
    })
    setCells(_ => randomizedCells)
  }

  <>
    <h1>{"The Game of Life!" -> React.string}</h1>
    <button onClick={(_)=>  {
      setCells(_ => Helpers.gridTick(
        ~cellsList=cells,
        ~cellsWide=cellsWide
      ))}}
      >
      {"increment Tick" -> React.string}
    </button>
    <button onClick={(_)=>  start()}>
      {"Start" -> React.string}
    </button>
    <button onClick={(_)=>  randomize()}>
      {"Randomize" -> React.string}
    </button>
    <div
      className="grid-container"
      style={
        ReactDOM.Style.make(
          ~width = gridWidth,
          ~gridTemplateColumns = "repeat(" ++ cellsWide -> Belt.Int.toString ++ ", " ++ cellWidthPx ++ ")",
          ()
        )
      }
    >
      {cells
        -> Belt.List.toArray
        -> Belt.Array.mapWithIndex((_, cell) => {
          <div onClick={(_) => toggleCell(cell)} className={"cell-item " ++ cell.state -> getCellClassNameByState} />
        })
        -> React.array}
    </div>
  </>
}