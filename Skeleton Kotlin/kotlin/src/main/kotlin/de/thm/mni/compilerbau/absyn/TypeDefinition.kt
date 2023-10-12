package de.thm.mni.compilerbau.absyn

import de.thm.mni.compilerbau.absyn.visitor.Visitor
import de.thm.mni.compilerbau.table.Identifier

/**
 * This class represents the definition of a type in SPL.
 *
 * When declaring a type, you have to provide a name, which is used as the identifier of this definition.
 * Additionally a [TypeExpression] has to be provided, which stands on the right hand side of the definition.
 *
 * @param position       The position of the definition in the source code.
 * @param name           The definitions identifier.
 * @param typeExpression The type expression associated with this definition.
 */
class TypeDefinition(position: Position, name: Identifier, val typeExpression: TypeExpression) : GlobalDefinition(position, name) {
    override fun accept(visitor: Visitor) = visitor.visit(this)

    override fun toString(): String = formatAst("TypeDefinition", name, typeExpression)

}
