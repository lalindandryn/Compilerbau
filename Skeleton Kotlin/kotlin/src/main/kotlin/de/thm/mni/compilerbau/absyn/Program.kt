package de.thm.mni.compilerbau.absyn

import de.thm.mni.compilerbau.absyn.visitor.Visitor

/**
 * This class represents the root of the AST.
 *
 * A program in SPL consists of a list of global definitions ([TypeDefinition] and [ProcedureDefinition]).
 *
 * @param position     The position of the SPL program in the source code. (This is usually the position of the first definition)
 * @param definitions The list of global definitions in the SPL program.
 */
class Program(position: Position, val definitions: List<GlobalDefinition>) : Node(position) {
    override fun accept(visitor: Visitor) = visitor.visit(this)

    override fun toString(): String = formatAst("Program", *definitions.toTypedArray())
}
