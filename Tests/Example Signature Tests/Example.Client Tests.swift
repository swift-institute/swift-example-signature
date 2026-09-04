import Client
import Either
import Example
import Example_Signature
import Example_Counter
import Example_Counter_Signature
import Example_Greeting
import Example_Greeting_Signature
import Tagged
import Tagged_Standard_Library_Integration
import Testing

private enum Transport: Swift.Error, Equatable {
    case unreachable
}

@Suite
struct `Example.Client Tests` {

    @Test
    func `an implementation of the signature is the local client`() async throws {
        var current: Example.Counter.Value = 0
        let example = Example.Product(
            greeting: Example.Greeting.Product(greet: Example.Greeting.greet),
            counter: Example.Counter.Product(
                increment: { limit throws(Example.Counter.Error) in
                    current = try Example.Counter.increment(current, limit: limit)
                    return current
                }
            )
        )

        #expect(await example.greeting.greet("Ada") == "Hello, Ada!")
        #expect(try await example.counter.increment(limit: 9) == 1)
        #expect(try await example.counter.increment(limit: 9) == 2)
    }

    @Test
    func `a refusal is the domain's own error`() async {
        let counter = Example.Counter.Product(
            increment: { limit throws(Example.Counter.Error) in
                try Example.Counter.increment(5, limit: limit)
            }
        )

        do throws(Example.Counter.Error) {
            _ = try await counter.increment(limit: 5)
            Issue.record("expected a refusal")
        } catch {
            #expect(error == .limit(reached: 5))
        }
    }

    @Test
    func `a client over a transport keeps its failure apart from the refusal`() async throws {
        let client = Example.Client<Transport>(
            greeting: .init(greet: .init { name throws(Either<Transport, Never>) in "hi \(name.underlying)" }),
            counter: .init(increment: .init { _ throws(Either<Transport, Example.Counter.Error>) in throw .left(.unreachable) })
        )

        #expect(try await client.greeting.greet("x") == "hi x")
        await #expect(throws: Either<Transport, Example.Counter.Error>.left(.unreachable)) {
            try await client.counter.increment(limit: 1)
        }
    }
}
