*Contents*
- [Over-arching Systems](#over-arching-systems)
- [Model of System Being Documented](#model-of-system-being-documented)
  - [The SystemModelBuilder](#the-systemmodelbuilder)
  - [Feeding into the SystemModelBuilder](#feeding-into-the-systemmodelbuilder)
- [Displaying the Model](#displaying-the-model)
  - [Cacao Display](#cacao-display)

# Over-arching Systems

SwiftCodeHelper uses AST as its core parsing technology.  Specifically SwiftAST (see https://github.com/yanagiba/swift-ast.git)

# Model of System Being Documented

The system being documented is further modeled using a light-weight set of structs.  These can be found in the Representation folder of the sources.  Generally, the class structure looks like this:

![](resource/SwiftCodeHelper-Representations.svg)

The SystemModel is the actual software system itself.  Its component parts are all members of the model.

## The SystemModelBuilder
SystemModels themselves are simple objects intended for use by renderers.  They do not have any logic for managing things like the relationships between types.  Instead, this task falls to the SystemModelBuilder.

## Feeding into the SystemModelBuilder
SystemModelBuilders themselves are driven by a SystemModellingVisitor, which is an implementation of the ASTVisitor protocol.  The model representation is thus constructed via standard AST method.

# Displaying the Model

The system provides a display protocol that can be used to render the software system visually:

![](resource/SwiftCodeHelper-View.svg)

To render a model simply get an instance of ModelDisplay and call display() with the model you wish to render.

## Cacao Display
In the works is a display implementation that will use the Cacao lib (a sort of UIKit for Linux) to display the system model on Linux machines.