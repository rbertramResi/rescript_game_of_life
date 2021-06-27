type cellState = Alive | Dead

type cell = {
  mutable state: cellState,
  id: int
}