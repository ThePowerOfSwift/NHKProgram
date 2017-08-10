import Foundation

public extension Sequence {
    public func forEachMutating(_ body: (inout Iterator.Element) throws -> Void) rethrows -> [Iterator.Element] {
        var result: [Iterator.Element] = []
        for x in self {
            var element = x
            try body(&element)
            result.append(element)
        }
        return result
    }
}
