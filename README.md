# swift-ui-autograph

Swift Package providing a view for capturing a users signature/autograph using drag gestures.
It is named autograph to avoid confusion with the overloaded word signature 😀

## Usage
It accepts a [Binding](https://developer.apple.com/documentation/swiftui/binding) to list of strokes represented as ```[[CGPoint]]``` for storing the strokes.
The points are in normalized form allowing for projection onto arbitrary canvas sizes.

For example if using a [SwiftData](https://developer.apple.com/documentation/swiftdata) backed model
```
@Model
class AutographCard {
    var strokes: [[CGPoint]]
}
```
A ``View`` can be constructed consisting of
```
    import SwiftData
    @Query private var autographs: [AutoGraphCard]

    var body: some View {
        
    ...
        if let autograph = autographs.first {
            Autograph($autograph.strokes)
        }
    ...
    }

```

## Output

The package provides a simple SVG encoder as an extension to ``[[CGPoint]]``.
This can be used by calling ``svg(strokeWidth:strokeColor:on:)`` providing a [CGSize](https://developer.apple.com/documentation/corefoundation/cgsize) for the aspect ratio.
```
var body: some View {
...
  Autograph($autograph.strokes)
              
  Button("Print") {
      print("SVG output is: \n\(autograph.strokes.svg(on: CGSize(width: 2, height: 1)) ?? "nil")")
  }
...
}
```

## Rendering in SwiftUI

To display the autograph in a view you can use the provided ``AutographShape`` implementation of [Shape](https://developer.apple.com/documentation/swiftui/shape), or use the ``path(in:)`` extension directly to create more advanced shapes.

## ObservableObject (Pre SwiftData) usage

Since the view accepts the type ``Binding<[[CGPoint]]`` any [``Published``](https://developer.apple.com/documentation/combine/published) reference of that type can be used by accesing its binding with the `$` operator.

## Documentation

The latest documentation is [hosted here](https://jensmoes.github.io/swift-ui-autograph/documentation/autograph/autograph/)

## See also

The [Demo Project](https://github.com/jensmoes/swift-ui-autograph/tree/main/AutographDemo) included in this package has usage examples based on a SwiftData model scheme, showing how to create and display autographs.
