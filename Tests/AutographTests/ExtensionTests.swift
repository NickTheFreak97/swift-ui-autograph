//
//  ExtensionTests.swift
//  
//
//  Created by Jens Troest on 3/23/24.
//

import XCTest

final class ExtensionTests: XCTestCase {

    let input = [
        [CGPoint(x: 0.2, y: 0.5),
         CGPoint(x: 0.5, y: 1.0)]
    ]
    
    func testPath() throws {
        let canvas = CGSize(width: 20.0, height: 10.0)
        XCTAssertEqual(input.path(in: canvas).description, "4 5 m 10 10 l")
    }

    func testSVG() throws {
        let canvas = CGSize(width: 20.0, height: 10.0)
        XCTAssertEqual(input.svg(strokeWidth: 0.5, strokeColor: "purple", on: canvas), "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"20.0\" height=\"10.0\" fill=\"none\" stroke=\"purple\" stroke-width=\"0.5\">\n<path d=\"M4.0 5.0 L10.0 10.0 \"/>\n</svg>\n")
    }
}
