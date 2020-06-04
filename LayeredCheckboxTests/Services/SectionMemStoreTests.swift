//
//  SectionMemStoreTests.swift
//  LayeredCheckboxTests
//
//  Created by Justine Tabin on 6/3/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import LayeredCheckbox

class SectionMemStoreTests: XCTestCase {
    
    var sut: SectionMemStore!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = SectionMemStore()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testCreate_whenGotSection_thenShouldMatchGivenSection() {
        // given
        let expect = expectation(description: "Wait for sut.create to return value")
        let expectedSection = Section(title: "ASDF12", items: [Item(title: "item", subtitle: "DEF")])
        
        // when
        var gotSection: Section?
        sut.create(section: expectedSection) { (section) in
            gotSection = section
            expect.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotSection, expectedSection)
    }
    
    func testListSections_whenGotSections_thenShouldMatchGivenSections() {
        // given
        let expect = expectation(description: "Wait for sut.list to return values")
        let expectedSections = [
            Section(title: "ASDF12", items: [Item(title: "item", subtitle: "DEF")]),
            Section(title: "12QWER", items: [Item(title: "item", subtitle: "DEF")]),
        ]
        sut.sections = expectedSections
        
        // when
        var gotSections: [Section]?
        sut.list { (sections) in
            gotSections = sections
            expect.fulfill()
        }
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotSections, expectedSections)
    }

}
