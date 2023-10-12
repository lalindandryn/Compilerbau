package de.thm.mni.compilerbau.absyn

import de.thm.mni.compilerbau.absyn.visitor.Visitor
import de.thm.mni.compilerbau.table.Identifier

/**
 * This class represents the definition of a procedure in SPL.
 *
 * When declaring a procedure, you have to provide a name, which is used as an identifier in this definition.
 * Additionally a definition of a procedure, declares its parameters as a list, a list of local variables and
 * a list of statements in the body of the procedure.
 *
 * @param position   The position of the procedure in the source code.
 * @param name       The procedures identifier.
 * @param parameters The procedures parameter list.
 * @param variables  The procedures local variables.
 * @param body       The statements in the procedures body.
 */
class ProcedureDefinition(
    position: Position,
    name: Identifier,
    val parameters: List<ParameterDefinition>,
    val variables: List<VariableDefinition>,
    val body: List<Statement>
) : GlobalDefinition(position, name) {
    override fun accept(visitor: Visitor) = visitor.visit(this)

    override fun toString(): String = formatAst(
        "ProcedureDefinition",
        name,
        formatAst("Parameters", *parameters.toTypedArray()),
        formatAst("Variables", *variables.toTypedArray()),
        formatAst("Body", *body.toTypedArray())
    )
}
