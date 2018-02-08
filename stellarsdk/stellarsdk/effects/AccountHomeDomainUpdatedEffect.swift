//
//  AccountHomeDomainUpdatedEffect.swift
//  stellarsdk
//
//  Created by Rogobete Christian on 05.02.18.
//  Copyright © 2018 Soneso. All rights reserved.
//

///  Represents an account home domain updated effect.
///  See [Horizon API](https://www.stellar.org/developers/horizon/reference/resources/effect.html "Account Home Domain Updated Effect")
///  See [Stellar guides](https://www.stellar.org/developers/guides/concepts/accounts.html#home-domain "Home Domain")
public class AccountHomeDomainUpdatedEffect: Effect {
    
    /// The home domain of the account.
    public var homeDomain:String
    
    // Properties to encode and decode
    private enum CodingKeys: String, CodingKey {
        case homeDomain = "home_domain"
    }
    
    /**
        Initializer - creates a new instance by decoding from the given decoder.
     
        - Parameter decoder: The decoder containing the data
     */
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        homeDomain = try values.decode(String.self, forKey: .homeDomain)
        
        try super.init(from: decoder)
    }
    
    /**
        Encodes this value into the given encoder.
     
        - Parameter encoder: The encoder to receive the data
     */
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(homeDomain, forKey: .homeDomain)
    }
}

