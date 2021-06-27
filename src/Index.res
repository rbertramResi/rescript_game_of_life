switch(ReactDOM.querySelector("#root")) {
  | Some(root) => ReactDOM.render(<App />, root)
  | None => Js.log("Unable to find root :(")
}
 