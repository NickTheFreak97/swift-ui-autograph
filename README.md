# swift-ui-autograph

Swift Package providing a view for capturing a users signature/autograph using drag gestures.
Curently it supports output in SVG format.

Requires an instance conforming to the `Autographic` protocol for storing the input.

You canuse the provided default implementation `AutoGraphData()` or provide a custom implementation.

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

See the [Demo Project]([url](https://github.com/jensmoes/swift-ui-autograph/tree/main/AutographDemo)https://github.com/jensmoes/swift-ui-autograph/tree/main/AutographDemo) for more usage examples.
