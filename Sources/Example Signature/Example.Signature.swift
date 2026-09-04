public import Client_Derivation
public import Example
public import Example_Counter
public import Example_Counter_Signature
public import Example_Greeting
public import Example_Greeting_Signature
public import Signature_Derivation

extension Example {
    @Signature
    @Client
    public protocol `Protocol` {
        associatedtype Greeting: Example::Example.Greeting.`Protocol`
        associatedtype Counter: Example::Example.Counter.`Protocol`

        var greeting: Greeting { get }
        var counter: Counter { get }
    }
}
