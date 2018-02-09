//
//  OperationLinksResponse.swift
//  stellarsdk
//
//  Created by Rogobete Christian on 08.02.18.
//  Copyright © 2018 Soneso. All rights reserved.
//

/// Represents the links connected to an operation response.
/// See [Horizon API](https://www.stellar.org/developers/horizon/reference/resources/operation.html "Operation")
public class OperationLinksResponse: NSObject, Codable {
    
    /// Link to the effects of this operation.
    public var effects:LinkResponse
    
    /// Link to the current operation respones.
    public var selfLink:LinkResponse
    
    /// Link to the transaction of this operation.
    public var transaction:LinkResponse
    
    /// Link to the next operation.
    public var precedes:LinkResponse
    
    /// Link to the previous operation.
    public var succeeds:LinkResponse
    
    
    // Properties to encode and decode.
    enum CodingKeys: String, CodingKey {
        case effects
        case selfLink = "self"
        case transaction
        case precedes
        case succeeds
    }
    
    /**
     Initializer - creates a new instance by decoding from the given decoder.
     
     - Parameter decoder: The decoder containing the data
     */
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        effects = try values.decode(LinkResponse.self, forKey: .effects)
        selfLink = try values.decode(LinkResponse.self, forKey: .selfLink)
        transaction = try values.decode(LinkResponse.self, forKey: .transaction)
        precedes = try values.decode(LinkResponse.self, forKey: .precedes)
        succeeds = try values.decode(LinkResponse.self, forKey: .succeeds)
    }
    
    /**
     Encodes this value into the given encoder.
     
     - Parameter encoder: The encoder to receive the data
     */
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(effects, forKey: .effects)
        try container.encode(selfLink, forKey: .selfLink)
        try container.encode(transaction, forKey: .transaction)
        try container.encode(precedes, forKey: .precedes)
        try container.encode(succeeds, forKey: .succeeds)
    }
}
