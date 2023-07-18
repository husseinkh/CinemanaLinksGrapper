import Foundation

// MARK: - SkippingDurations
/// It is used to record start and end period 
public struct SkippingDurations: Codable {
    public let start: [String]
    public let end: [String]

    enum CodingKeys: String, CodingKey {
        case start = "start"
        case end = "end"
    }

    public init(start: [String], end: [String]) {
        self.start = start
        self.end = end
    }
}
