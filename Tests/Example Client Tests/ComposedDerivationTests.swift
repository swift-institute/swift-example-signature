import Algebra_Derivation
public import Call_Derivation
import Client
public import Example
public import Example_Counter
import Testing

public enum ComposedDerivationFixture {
    @Algebra
    @Calls
    package protocol Signature {
        func greet(_ name: String) async -> String
        func increment(limit: Int) async throws(Example.Counter.Error) -> Int
    }
}

@Test
func algebraInterpretsAProductCallCoproduct() async throws {
    let client = ComposedDerivationFixture.Client(
        greet: { "Hello, \($0)" },
        increment: { limit throws(Example.Counter.Error) in
            guard limit > 0 else {
                throw .limit(reached: .init(limit))
            }
            return limit + 1
        }
    )

    let greeting = try await client(.greet("Ada"))
    let message: String? = if case .greet(let value) = greeting { value } else { nil }
    #expect(message == .some("Hello, Ada"))

    let increment = try await client(.increment(limit: 2))
    let value: Int? = if case .increment(let value) = increment { value } else { nil }
    #expect(value == .some(3))

    do throws(ComposedDerivationFixture.Call.Failure) {
        _ = try await client(.increment(limit: 0))
        Issue.record("expected a refusal")
    } catch {
        let reached: Example.Counter.Limit? = if case .increment(
            .limit(reached: let limit)
        ) = error {
            limit
        } else {
            nil
        }
        #expect(reached == .some(.init(0)))
    }
}
