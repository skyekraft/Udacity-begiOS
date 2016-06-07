//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    

// TODO: Add the computed property, cells.
    
    var cells: [GridLocation] {
        get {
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
            
            var occupiedCells = [GridLocation]()
            
            if isVertical == false {
            for x in start.x...end.x {
                    occupiedCells.append(GridLocation(x: x, y: start.y))
                }
            } else {
                
            for y in start.y...end.y {
                    occupiedCells.append(GridLocation(x: start.x, y: y))
                }
            }
        return occupiedCells
    }
}
        
    var hitTracker: HitTracker
// TODO: Add a getter for sunk. Calculate the value returned using hitTracker.cellsHit.
    var sunk: Bool {
        get {
            for d in cells {
                if hitTracker.cellsHit[d] == false {
                    return false
                }
            }
            return true
        }
    }

// TODO: Add custom initializers

    init(length: Int, location: GridLocation, isVertical: Bool) {
        self.length = length
        self.hitTracker = HitTracker()
        self.isVertical = isVertical
        self.location = location
        self.isWooden = false
    }
    
    init(length: Int, location: GridLocation, isVertical: Bool, isWooden: Bool) {
        self.length = length
        self.hitTracker = HitTracker()
        self.isVertical = isVertical
        self.location = location
        self.isWooden = isWooden
    }
}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol PenaltyCell {
    var location: GridLocation {get}
    var guaranteesHit: Bool {get set}
    var penaltyText: String {get}
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: PenaltyCell {
    let location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String
    
    init(location: GridLocation, penaltyText: String) {
        self.location = location
        self.guaranteesHit = false
        self.penaltyText = penaltyText
    }
    init(location: GridLocation, guaranteesHit: Bool, penaltyText: String) {
        self.location = location
        self.guaranteesHit = guaranteesHit
        self.penaltyText = penaltyText
    }
}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: PenaltyCell {
    let location: GridLocation
    var guaranteesHit: Bool
    var penaltyText: String
    
    init(location: GridLocation, penaltyText: String) {
        self.location = location
        self.guaranteesHit = false
        self.penaltyText = penaltyText
    }
    init(location: GridLocation, guaranteesHit: Bool, penaltyText: String) {
        self.location = location
        self.guaranteesHit = guaranteesHit
        self.penaltyText = penaltyText
    }
}

class ControlCenter {
    
    func placeItemsOnGrid(human: Human) {
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true)
        human.addShipToGrid(smallShip)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false, isWooden: true)
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false)
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true, isWooden: true)
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true)
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(location: GridLocation(x: 6, y: 0), guaranteesHit: true, penaltyText: "Mine #1 hit! Opponent gets a guaranteed hit.")
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(location: GridLocation(x: 3, y: 3), penaltyText: "Mine #2 hit! Oppponent gets a guaranteed hit.")
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6), guaranteesHit: true, penaltyText: "First SeaMonster hit!")
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2), guaranteesHit: true, penaltyText: "Second SeaMonster hit!")
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}