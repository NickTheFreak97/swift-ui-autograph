# swift-ui-autograph

Swift Package providing a view for capturing a users signature/autograph using drag gestures.

Requires an instance conforming to the [`Autographic`](https://github.com/jensmoes/swift-ui-autograph/blob/main/Sources/Autograph/DataModel.swift#L11-L50) protocol for storing the input.

You can use the provided default implementation `AutoGraphData()` or provide a custom implementation.

```
class MyAppData: ObservableObject {
....
    @Published var autograph = AutoGraphData()
}
```
View example:
```
@EnvironmentObject var myAppData: MyAppData
....

var body: some View {
...
  Autograph(data: myAppData.autograph, strokeColor: .blue)
              
  Button("Print") {
      print("SVG output is: \n\(myAppData.autograph.svg ?? "nil")")
  }
...
}
```

Curently it supports [output in SVG format](https://github.com/jensmoes/swift-ui-autograph/blob/main/Sources/Autograph/DataModel.swift#L125)

See the [Demo Project](https://github.com/jensmoes/swift-ui-autograph/tree/main/AutographDemo) for more usage examples.
