import GameplayKit

struct SeededGenerator: RandomNumberGenerator {
    private let generator: GKMersenneTwisterRandomSource

    init(seed: UInt64) {
        self.generator = GKMersenneTwisterRandomSource(seed: seed)
    }

    mutating func next() -> UInt64 {
        let next = generator.nextInt()
        return UInt64(bitPattern: Int64(next))
    }
}

func manyOf(_ options: [String], count: Int, seed: Int) -> [String] {
    var generator = SeededGenerator(seed: UInt64(seed))
    return Array(options.shuffled(using: &generator).prefix(count))
}
