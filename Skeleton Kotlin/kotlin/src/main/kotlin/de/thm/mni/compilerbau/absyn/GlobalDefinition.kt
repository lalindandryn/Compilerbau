package de.thm.mni.compilerbau.absyn

import de.thm.mni.compilerbau.table.Identifier

/**
 * This class is the abstract superclass of every global definition in SPL.
 *
 * Global definitions are all definitions done in the global scope.
 * This definitions may either be a [TypeDefinition] or a [ProcedureDefinition].
 *
 * @param position The global definitions position in the source code.
 * @param name     The identifier for this global definition.
 */
sealed class GlobalDefinition(position: Position, val name: Identifier) : Node(position)
