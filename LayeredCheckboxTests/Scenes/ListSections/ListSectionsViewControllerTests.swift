//
//  ListSectionsViewControllerTests.swift
//  LayeredCheckboxTests
//
//  Created by Justine Tabin on 6/3/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
import RxSwift
@testable import LayeredCheckbox

class ListSectionsViewControllerTests: XCTestCase {
    
    var window: UIWindow!
    var sectionStore: MockSectionStore!
    var sut: ListSectionsViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sectionStore = MockSectionStore()
        let dependencyWorker = DependencyWorker(sectionStore: sectionStore)
        sut = dependencyWorker.makeListSections()
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = sut
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        window = nil
    }
    
    func testTableView_whenViewDidLoad_thenShouldDisplaySections() {
        // given
        let expect = expectation(description: "Wait for output.displayableTableSections to receive a value")
        let expectedNumberOfSections = sectionStore.sections.count
        
        // when
        var gotSections: [ListSectionsViewModel.DisplayableTableSection]?
        sut.viewModel.output.displayableTableSections
            .skip(1)
            .bind { (sections) in
                gotSections = sections
                expect.fulfill()
            }
            .disposed(by: sut.disposeBag)
        window.makeKeyAndVisible()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(sut.tableView.tableHeaderView is LayerOneTableHeaderView)
        XCTAssertEqual(sut.numberOfSections(in: sut.tableView), expectedNumberOfSections)
        gotSections?.enumerated().forEach { (sectionIndex, section) in
            section.items.enumerated().forEach { (itemIndex, item) in
                XCTAssert(sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: itemIndex, section: sectionIndex)) is LayerThreeCheckBoxTableViewCell)
            }
            XCTAssert(sut.tableView(sut.tableView, viewForHeaderInSection: sectionIndex) is LayerTwoSectionHeaderView)
            XCTAssertEqual(sut.tableView(sut.tableView, numberOfRowsInSection: sectionIndex), section.items.count)
        }
    }
    
    func testLayerOneView_whenTapped_thenShouldCheckAll() {
        // given
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        let expectedCheckAll = [true, false]
        
        // when
        var gotCheckAllSequence: [Bool] = []
        sut.viewModel.output.checkAll
            .skip(1)
            .bind { (isChecked) in
                gotCheckAllSequence.append(isChecked)
                expect.fulfill()
            }.disposed(by: sut.disposeBag)
        sut.viewModel.output.displayableTableSections
            .skip(1)
            .bind { [unowned self] (_) in
                self.sut.layerOneTableHeaderView.titleButton.sendActions(for: .touchUpInside)
                self.sut.layerOneTableHeaderView.checkbox.isChecked.toggle()
                self.sut.layerOneTableHeaderView.checkbox.sendActions(for: .valueChanged)
            }
            .disposed(by: sut.viewModel.disposeBag)
        
        window.makeKeyAndVisible()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotCheckAllSequence, expectedCheckAll)
    }
    
    func testLayerTwoView_threeView_whenExpandedSection_tappedItem_thenShouldExpandSection_checkItem() {
        // given
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        
        // when
        sut.viewModel.output.sectionExpand
            .delay(RxTimeInterval.microseconds(10), scheduler: MainScheduler.instance)
            .bind { [unowned self] (_) in
                self.sut.tableView(self.sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
                expect.fulfill()
            }
            .disposed(by: sut.viewModel.disposeBag)

        var gotItemChecked: Bool?
        sut.viewModel.output.itemCheck
            .bind { (_, _, _, item) in
                gotItemChecked = item.isChecked
                expect.fulfill()
            }
            .disposed(by: sut.viewModel.disposeBag)
        
        sut.viewModel.output.displayableTableSections
            .skip(1)
            .delay(RxTimeInterval.microseconds(10), scheduler: MainScheduler.instance)
            .bind { [unowned self] (sections) in
                let headerView = self.sut.tableView(self.sut.tableView, viewForHeaderInSection: 0) as! LayerTwoSectionHeaderView
                headerView.titleButton.sendActions(for: .touchUpInside)
            }
            .disposed(by: sut.viewModel.disposeBag)
        window.makeKeyAndVisible()
        
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotItemChecked, true)
    }

}
