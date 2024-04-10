import XCTest
@testable import Autograph
import SwiftUI

final class AutographTests: XCTestCase {
    
    @ObservedObject var model = MockModel()

    // Subject under test
    var sut: AutographViewModel!
    override func setUp() {
        model = MockModel()
        sut = AutographViewModel(data: $model.strokes)//Autograph($model.strokes, canvasSize: $model.canvas)
    }

    func testEndStroke() throws {
        sut.addPoint(CGPoint(x: 1, y: 2), from: model.canvas)
        XCTAssert(model.strokes.count == 1)
        XCTAssertEqual(model.strokes[0].count, 1)
        sut.endStroke()
        XCTAssert(model.strokes.isEmpty)
        
        // Two points, endstroke should have no effect
        sut.addPoint(CGPoint(x: 1, y: 2), from: model.canvas)
        sut.addPoint(CGPoint(x: 2, y: 1), from: model.canvas)
        sut.endStroke()
        XCTAssertEqual(model.strokes.count, 1)
        XCTAssertEqual(model.strokes[0].count, 2)

    }

    func testAddStrokes() throws {
        sut.addPoint(.zero, from: model.canvas, isFirst: true)
        sut.addPoint(CGPoint(x: 100, y: 200), from: model.canvas)
        sut.endStroke()
        sut.addPoint(CGPoint(x: 50, y: 100), from: model.canvas, isFirst: true)
        sut.addPoint(CGPoint(x: 51, y: 101), from: model.canvas)
        sut.endStroke()
        XCTAssertEqual(model.strokes.count, 2)
        XCTAssertEqual(model.strokes[0].count, 2)
        XCTAssertEqual(model.strokes[1].count, 2)
    }

    /// Tests the reuse of a preexisting stroke with only one point
    func testOnePointStrokeRecycling() throws {
        
        // Add two strokes, with the last stroke containing one point
        sut.addPoint(.zero, from: model.canvas, isFirst: true)
        sut.addPoint(CGPoint(x: 1, y: 1), from: model.canvas)
        sut.addPoint(.zero, from: model.canvas, isFirst: true)
        
        XCTAssertEqual(model.strokes.count, 2)
        XCTAssertEqual(model.strokes[1].count, 1)
        XCTAssertEqual(model.strokes[1][0], .zero)
        sut.addPoint(CGPoint(x: 0.5, y: 0.5), from: .init(width: 1, height: 1), isFirst: true)
        XCTAssertEqual(model.strokes.count, 2)
        XCTAssertEqual(model.strokes[1].count, 1)
        XCTAssertEqual(model.strokes[1][0], CGPoint(x: 0.5, y: 0.5))

    }
    
    func testNormalization() throws {
        let canvas = CGSize(width: 20.0, height: 10.0)
        sut.addPoint(CGPoint(x: 4, y: 5), from: canvas)
        XCTAssertEqual(model.strokes[0][0], .init(x: 0.2, y: 0.5))
    }

}

/// A mock containing the data for the test object
class MockModel: ObservableObject {
    internal init(strokes: [[CGPoint]] = []) {
        self.strokes = strokes
    }
    @Published var strokes: [[CGPoint]]
    @Published var canvas: CGSize = .init(width: 2, height: 1)
}
