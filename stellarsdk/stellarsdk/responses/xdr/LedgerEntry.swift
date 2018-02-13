//
//  LedgerEntry.swift
//  stellarsdk
//
//  Created by Rogobete Christian on 12.02.18.
//  Copyright © 2018 Soneso. All rights reserved.
//

import Foundation


public enum LedgerEntryChangeType: Int32 {
    case ledgerEntryCreated = 0
    case ledgerEntryUpdated = 1
    case ledgerEntryRemoved = 2
    case ledgerEntryState = 3
}

public enum LedgerEntryType: Int32 {
    case account = 0
    case trustline = 1
    case offer = 2
    case data = 3
}

public struct LedgerEntryChanges: XDRCodable {
    public let LedgerEntryChanges: [LedgerEntryChange]
    
    public init(LedgerEntryChanges: [LedgerEntryChange]) {
        self.LedgerEntryChanges = LedgerEntryChanges
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        LedgerEntryChanges = try container.decode([LedgerEntryChange].self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(LedgerEntryChanges)
    }
}

public enum LedgerEntryChange: XDRCodable {
    case created (LedgerEntry)
    case updated (LedgerEntry)
    case removed (LedgerKey)
    case state (LedgerEntry)
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        let type = try container.decode(Int32.self)
        
        switch type {
        case LedgerEntryChangeType.ledgerEntryCreated.rawValue:
            self = .created(try container.decode(LedgerEntry.self))
        case LedgerEntryChangeType.ledgerEntryUpdated.rawValue:
            self = .updated(try container.decode(LedgerEntry.self))
        case LedgerEntryChangeType.ledgerEntryUpdated.rawValue:
            self = .removed(try container.decode(LedgerKey.self))
        case LedgerEntryChangeType.ledgerEntryState.rawValue:
            self = .state(try container.decode(LedgerEntry.self))
        default:
            self = .created(try container.decode(LedgerEntry.self))
        }
    }
    
    private func type() -> Int32 {
        switch self {
        case .created: return LedgerEntryChangeType.ledgerEntryCreated.rawValue
        case .updated: return LedgerEntryChangeType.ledgerEntryUpdated.rawValue
        case .removed: return LedgerEntryChangeType.ledgerEntryRemoved.rawValue
        case .state: return LedgerEntryChangeType.ledgerEntryState.rawValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        
        try container.encode(type())
        
        switch self {
        case .created (let op):
            try container.encode(op)
            
        case .updated (let op):
            try container.encode(op)
            
        case .removed (let op):
            try container.encode(op)
            
        case .state (let op):
            try container.encode(op)
        }
    }
}

public struct LedgerEntry: XDRCodable {
    public let lastModifiedLedgerSeq: UInt32;
    public let data: LedgerEntryData
    public let reserved: Int32 = 0
    
    
    public init(lastModifiedLedgerSeq: UInt32, data:LedgerEntryData) {
        self.lastModifiedLedgerSeq = lastModifiedLedgerSeq
        self.data = data
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        lastModifiedLedgerSeq = try container.decode(UInt32.self)
        data = try container.decode(LedgerEntryData.self)
        _ = try container.decode(Int32.self)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(lastModifiedLedgerSeq)
        try container.encode(data)
        try container.encode(reserved)
    }
    
    public enum LedgerEntryData: XDRCodable {
        case account (AccountEntry)
        case trustline (TrustlineEntry)
        case offer (OfferEntry)
        case data (DataEntry)
        
        public init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            
            let type = try container.decode(Int32.self)
            
            switch type {
                case LedgerEntryType.account.rawValue:
                    self = .account(try container.decode(AccountEntry.self))
                case LedgerEntryType.trustline.rawValue:
                    self = .trustline(try container.decode(TrustlineEntry.self))
                case LedgerEntryType.offer.rawValue:
                    self = .offer(try container.decode(OfferEntry.self))
                case LedgerEntryType.data.rawValue:
                    self = .data(try container.decode(DataEntry.self))
                default:
                    self = .account(try container.decode(AccountEntry.self))
            }
        }
        
        public func type() -> Int32 {
            switch self {
                case .account: return LedgerEntryType.account.rawValue
                case .trustline: return LedgerEntryType.trustline.rawValue
                case .offer: return LedgerEntryType.offer.rawValue
                case .data: return LedgerEntryType.data.rawValue
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            
            try container.encode(type())
            
            switch self {
                case .account (let op):
                    try container.encode(op)
                
                case .trustline (let op):
                    try container.encode(op)
                
                case .offer (let op):
                    try container.encode(op)
                
                case .data (let op):
                    try container.encode(op)
            }
        }
    }
}

public enum LedgerKey: XDRCodable {
    case account (LedgerKeyAccount)
    case trustline (LedgerKeyTrustLine)
    case offer (LedgerKeyOffer)
    case data (LedgerKeyData)
    
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        let type = try container.decode(Int32.self)
        
        switch type {
            case LedgerEntryType.account.rawValue:
                let acc = try container.decode(LedgerKeyAccount.self)
                self = .account(acc)
            case LedgerEntryType.trustline.rawValue:
                let trus = try container.decode(LedgerKeyTrustLine.self)
                self = .trustline(trus)
            case LedgerEntryType.offer.rawValue:
                let offeru = try container.decode(LedgerKeyOffer.self)
                self = .offer(offeru)
            case LedgerEntryType.data.rawValue:
                let datamu = try container.decode(LedgerKeyData.self)
                self = .data (datamu)
            default:
                let acc = try container.decode(LedgerKeyAccount.self)
                self = .account(acc)
        }
    }
    
    public struct LedgerKeyAccount: XDRCodable {
        let accountID: PublicKey
        
        init(accountID: PublicKey) {
            self.accountID = accountID
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(accountID)
        }
    }
    
    public struct LedgerKeyTrustLine: XDRCodable {
        let accountID: PublicKey
        let asset: Asset
        
        init(accountID: PublicKey, asset: Asset) {
            self.accountID = accountID
            self.asset = asset
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(accountID)
            try container.encode(asset)
        }
    }
    
    public struct LedgerKeyOffer: XDRCodable {
        let sellerId: PublicKey
        let offerId: UInt64
        
        init(sellerId: PublicKey, offerId: UInt64) {
            self.sellerId = sellerId
            self.offerId = offerId
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(sellerId)
            try container.encode(offerId)
        }
    }
    
    public struct LedgerKeyData: XDRCodable {
        let accountId: PublicKey
        let dataName: String
        
        init(accountId: PublicKey, dataName: String) {
            self.accountId = accountId
            self.dataName = dataName
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(accountId)
            try container.encode(dataName)
        }
    }
    
    public func type() -> Int32 {
        switch self {
            case .account: return LedgerEntryType.account.rawValue
            case .trustline: return LedgerEntryType.trustline.rawValue
            case .offer: return LedgerEntryType.offer.rawValue
            case .data: return LedgerEntryType.data.rawValue
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(type())
        
        switch self {
            case .account (let acc):
                try container.encode(acc)
            case .trustline (let trust):
                try container.encode(trust)
            case .offer (let offeru):
                try container.encode(offeru)
            case .data (let datamu):
                try container.encode(datamu)
        }
    }
}
