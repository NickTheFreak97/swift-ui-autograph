# swift-ui-autograph

Swift Package providing a view for capturing a users signature/autograph using drag gestures.
It is named autograph to avoid confusion with the overloaded word signature 😀

## Usage
It accepts a [Binding](https://developer.apple.com/documentation/swiftui/binding) to list of strokes represented as ```[[CGPoint]]``` for storing the strokes.

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
            
            Autograph(autograph)
                      
            Button("Print") {
                print("SVG output is: \n\(autograph.svg(on: canvasSize) ?? "nil")")
            }
        }
    ...
    }

```

## Output

The package provides a simple SVG encoder as an extension to ``[[CGPoint]]``.
This can be used by calling ``svg(strokeWidth:strokeColor:on:)``
```
var body: some View {
...
  Autograph(autograph, strokeColor: .blue)
              
  Button("Print") {
      print("SVG output is: \n\(autograph.svg(on: CGSize(width: 2, height: 1)) ?? "nil")")
  }
...
}
```

## Rendering in SwiftUI

To display the autograph in a view you can use the provided ``AutographShape`` implementation of [Shape](https://developer.apple.com/documentation/swiftui/shape) directly or use the ``path(in:)`` extension directly to create advanced shapes.

## See also

The [Demo Project](https://github.com/jensmoes/swift-ui-autograph/tree/main/AutographDemo) included in this package has usage examples based on a SwiftData model scheme, showing how to create and display autographs.
