*Contents*
- [Over-arching Systems](#over-arching-systems)
- [Model of System Being Documented](#model-of-system-being-documented)
  - [The SystemModelBuilder](#the-systemmodelbuilder)
  - [Feeding into the SystemModelBuilder](#feeding-into-the-systemmodelbuilder)

# Over-arching Systems

SwiftCodeHelper uses AST as its core parsing technology.  Specifically SwiftAST (see https://github.com/yanagiba/swift-ast.git)

# Model of System Being Documented

The system being documented is further modeled using a light-weight set of structs.  These can be found in the Representation folder of the sources.  Generally, the class structure looks like this:

![](resource/SwiftCodeHelper.svg)

The SystemModel is the actual software system itself.  Its component parts are all members of the model.

## The SystemModelBuilder
SystemModels themselves are simple objects intended for use by renderers.  They do not have any logic for managing things like the relationships between types.  Instead, this task falls to the SystemModelBuilder.

## Feeding into the SystemModelBuilder
SystemModelBuilders themselves are driven by a SystemModellingVisitor, which is an implementation of the ASTVisitor protocol.  The model representation is thus constructed via standard AST method.