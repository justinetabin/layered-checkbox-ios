//
//  ListSectionsViewModelTests.swift
//  LayeredCheckboxTests
//
//  Created by Justine Tabin on 6/3/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
import RxSwift
@testable import LayeredCheckbox

class ListSectionsViewModelTests: XCTestCase {

    var sectionMemStore: MockSectionStore!
    var sut: ListSectionsViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sectionMemStore = MockSectionStore()
        let dependencyWorker = DependencyWorker(sectionStore: sectionMemStore)
        sut = ListSectionsViewModel(factory: dependencyWorker)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sectionMemStore = nil
        sut = nil
    }
    
    func testInput_whenViewDidLoad_thenShouldOutputDisplayableSections() {
        // given
        let expect = expectation(description: "Wait for output.displayableTableSections receives value.")
        expect.expectedFulfillmentCount = 2
        let expectedSectionCount = [0, sectionMemStore.sections.count]
        
        // when
        var gotSectionCount: [Int] = []
        sut.output.displayableTableSections
            .bind { (sections) in
                gotSectionCount.append(sections.count)
                expect.fulfill()
            }.disposed(by: sut.disposeBag)
        sut.input.viewDidLoad.accept(())
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(expectedSectionCount == gotSectionCount)
    }
    
    func testInput_whenCheckAll_thenShouldOutputCheckedAll() {
        // given
        let expect = expectation(description: "Wait for output.checkAll to receive a value")
        let expectedCheckedSectionCount = sectionMemStore.sections.count
        
        // when
        var gotIsChecked: Bool?
        var gotCheckAllState: CheckBoxState?
        var gotCheckedSections: [Bool]?
        sut.output.checkAll
            .skip(1)
            .bind { [unowned self] (isChecked) in
                gotCheckAllState = self.sut.output.checkAllState
                gotIsChecked = isChecked
                gotCheckedSections = self.sut.output.displayableTableSections.value.map { $0.isChecked }
                expect.fulfill()
            }.disposed(by: sut.disposeBag)
        
        sut.output.displayableTableSections
            .skip(1)
            .map { _ in true }
            .bind(to: sut.input.didTapCheckAll)
            .disposed(by: sut.disposeBag)
        sut.input.viewDidLoad.accept(())
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotIsChecked, true)
        XCTAssertEqual(gotCheckAllState, .checked)
        XCTAssertEqual(gotCheckedSections?.filter { $0 }.count, expectedCheckedSectionCount)
    }
    
    func testInput_whenExpandSection_thenShouldOutputExpandSection() {
        // given
        let expect = expectation(description: "Wait for output.sectionExpand to receive value")
        expect.expectedFulfillmentCount = 2
        let expectedExpandedSequence = [true, false]
        
        // when
        var gotIsExpendeds: [Bool] = []
        sut.output.sectionExpand
            .bind { [unowned self] (section) in
                gotIsExpendeds.append(self.sut.output.displayableTableSections.value[section].isExpanded)
                if gotIsExpendeds.count < 2 {
                    self.sut.input.didTapExpandSection.accept(0)
                }
                expect.fulfill()
            }.disposed(by: sut.disposeBag)
        
        sut.output.displayableTableSections
            .skip(1)
            .map { _ in 0 }
            .bind(to: sut.input.didTapExpandSection)
            .disposed(by: sut.disposeBag)
        
        sut.input.viewDidLoad.accept(())
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotIsExpendeds, expectedExpandedSequence)
    }
    
    func testInput_whenDidTapSectionCheck_thenShouldOutputCheckedSection_checkedItems() {
        // given
        let expect = expectation(description: "Wait for output.sectionCheck received value")
        
        // when
        var gotSectionCheck: Bool?
        var gotSectionCheckState: CheckBoxState?
        var gotItemChecks: [Bool]?
        sut.output.sectionCheck
            .bind { (sectionIndex, section) in
                gotSectionCheck = section.isChecked
                gotSectionCheckState = section.state
                gotItemChecks = section.items.map { $0.isChecked }
                expect.fulfill()
            }
            .disposed(by: sut.disposeBag)
        
        sut.output.displayableTableSections
            .skip(1)
            .map { _ in 0 }
            .bind(to: sut.input.didTapSectionCheck)
            .disposed(by: sut.disposeBag)
        
        sut.input.viewDidLoad.accept(())
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotSectionCheck, true)
        XCTAssertEqual(gotSectionCheckState, .checked)
        XCTAssertEqual(gotItemChecks?.filter { $0 }, gotItemChecks)
    }
    
    func testInput_whenDidTapItemCheck_thenShouldOutputCheckedItem_indeterminateSection() {
        // given
        let expect = expectation(description: "Wait for output.itemCheck receives value")
        
        // when
        var gotSectionState: CheckBoxState?
        var gotItemIsChecked: Bool?
        sut.output.itemCheck
            .bind { (sectionIndex, itemIndex, section, item) in
                gotSectionState = section.state
                gotItemIsChecked = item.isChecked
                expect.fulfill()
            }.disposed(by: sut.disposeBag)
        
        sut.output.displayableTableSections
            .skip(1)
            .map { _ in (0,0) }
            .bind(to: sut.input.didTapItem)
            .disposed(by: sut.disposeBag)
        
        sut.input.viewDidLoad.accept(())
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotSectionState, .indeterminate)
        XCTAssertEqual(gotItemIsChecked, true)
    }

}
