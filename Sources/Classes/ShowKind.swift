
//MARK:- Show Kind
/// Show type : Film , TVShow ..
public enum ShowKind : Int {
    case film = 1
    case tvShow = 2
    case unknown = 0
}

extension ShowKind : Codable {
    
    /// Convert it from String to Int and back
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {

            let strValue = try container.decode(String.self)
           let intValue = Int(strValue) ?? Self.unknown.rawValue
            self = .init(rawValue: intValue)  ?? .unknown
            // if let intValue = Int(strValue) {
            //     self = .init(rawValue: intValue) ?? .unknown
            // }
            // else {
            //     self = .unknown
            // }


        }
        catch  DecodingError.typeMismatch {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode("\(rawValue)")
    }
}

