package de.thm.mni.compilerbau.absyn

import de.thm.mni.compilerbau.absyn.visitor.Visitor
import de.thm.mni.compilerbau.table.Identifier

/**
 * This class represents the local definition of a parameter in SPL.
 *
 * Parameters are declared in the parameter list of a procedure. They combine an [Identifier] with
 * a [TypeExpression], expressing the parameters type and additionally have to store
 * whether the parameter is passed as a reference.
 * Parameters are only visible in the local scope of their procedure.
 *
 * @param position       The position of the definition in the source code.
 * @param name           The identifier of the declared parameter.
 * @param typeExpression The type expression used to express the parameters type.
 * @param isReference    A boolean value used to represent whether the parameter is passed as a reference.
 */
class ParameterDefinition(
    position: Position,
    val name: Identifier,
    val typeExpression: TypeExpression,
    val isReference: Boolean
) : Node(position) {
    override fun accept(visitor: Visitor) = visitor.visit(this)

    override fun toString(): String = formatAst("ParameterDefinition", name, typeExpression, isReference)

}
