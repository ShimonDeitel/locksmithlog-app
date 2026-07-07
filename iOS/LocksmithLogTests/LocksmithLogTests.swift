import XCTest
@testable import LocksmithLog

@MainActor
final class LocksmithLogTests: XCTestCase {

    func test_freshStore_hasSeedDataBelowFreeLimit() {
        let store = Store()
        XCTAssertLessThan(store.entries.count, Store.freeLimit)
    }

    func test_freshStore_canAddMore() {
        let store = Store()
        XCTAssertTrue(store.canAddMore)
    }

    func test_add_insertsEntry() {
        let store = Store()
        let before = store.entries.count
        store.add(VisitEntry(date: Date(), doorName: "Test Item"))
        XCTAssertEqual(store.entries.count, before + 1)
    }

    func test_add_respectsFreeLimit() {
        let store = Store()
        store.entries = []
        for i in 0..<Store.freeLimit {
            store.add(VisitEntry(date: Date(), doorName: "Item \(i)"))
        }
        XCTAssertFalse(store.canAddMore)
        let countAtLimit = store.entries.count
        store.add(VisitEntry(date: Date(), doorName: "Overflow"))
        XCTAssertEqual(store.entries.count, countAtLimit)
    }

    func test_isPro_bypassesFreeLimit() {
        let store = Store()
        store.isPro = true
        for i in 0..<(Store.freeLimit + 3) {
            store.add(VisitEntry(date: Date(), doorName: "Item \(i)"))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func test_delete_removesEntry() {
        let store = Store()
        let entry = VisitEntry(date: Date(), doorName: "Delete Me")
        store.add(entry)
        store.delete(entry)
        XCTAssertFalse(store.entries.contains(where: { $0.id == entry.id }))
    }

    func test_update_modifiesEntry() {
        let store = Store()
        var entry = VisitEntry(date: Date(), doorName: "Original")
        store.add(entry)
        entry.doorName = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first(where: { $0.id == entry.id })?.doorName, "Updated")
    }

    func test_deleteAtOffsets_removesCorrectEntry() {
        let store = Store()
        store.entries = []
        let a = VisitEntry(date: Date(), doorName: "A")
        let b = VisitEntry(date: Date(), doorName: "B")
        store.entries = [a, b]
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.entries.count, 1)
        XCTAssertEqual(store.entries.first?.id, b.id)
    }
}
