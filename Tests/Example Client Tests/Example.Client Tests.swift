import Client
import Either
import Example
import Example_Client
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
import Testing

private enum Transport: Swift.Error, Equatable {
    case unreachable
}

@Suite
struct `Example.Client Tests` {

    @Test
    func `an implementation of the signature is the local client`() async throws {
        var current = Example.Counter.Value(0)
        let example = Example.Product(
            greeting: Example.Greeting.Product(greet: Example.Greeting.greet),
            counter: Example.Counter.Product(
                increment: { limit throws(Example.Counter.Error) in
                    current = try Example.Counter.increment(current, limit: limit)
                    return current
                }
            )
        )

        #expect(await example.greeting.greet(.init("Ada")) == .init("Hello, Ada!"))
        #expect(try await example.counter.increment(limit: .init(9)) == .init(1))
        #expect(try await example.counter.increment(limit: .init(9)) == .init(2))
    }

    @Test
    func `a refusal is the domain's own error`() async {
        let counter = Example.Counter.Product(
            increment: { limit throws(Example.Counter.Error) in
                try Example.Counter.increment(.init(5), limit: limit)
            }
        )

        do throws(Example.Counter.Error) {
            _ = try await counter.increment(limit: .init(5))
            Issue.record("expected a refusal")
        } catch {
            #expect(error == .limit(reached: .init(5)))
        }
    }

    @Test
    func `a client over a transport keeps its failure apart from the refusal`() async throws {
        let client = Example.Client<Transport>(
            greeting: .init(greet: .init { name throws(Either<Transport, Never>) in .init("hi \(name.underlying)") }),
            counter: .init(increment: .init { _ throws(Either<Transport, Example.Counter.Error>) in throw .left(.unreachable) })
        )

        #expect(try await client.greeting.greet(.init("x")) == .init("hi x"))
        await #expect(throws: Either<Transport, Example.Counter.Error>.left(.unreachable)) {
            try await client.counter.increment(limit: .init(1))
        }
    }
}
