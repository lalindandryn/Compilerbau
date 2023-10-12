package de.thm.mni.compilerbau.absyn;

import de.thm.mni.compilerbau.table.Identifier;

/**
 * This class is the abstract superclass of every global declaration in SPL.
 * <p>
 * Global definitions are all definitions done in the global scope.
 * This definitions may either be a {@link TypeDefinition} or a {@link ProcedureDefinition}.
 */
sealed public abstract class GlobalDefinition extends Node permits ProcedureDefinition, TypeDefinition {
    public final Identifier name;

    /**
     * Creates a new node representing a global declaration.
     *
     * @param position The global definitions position in the source code.
     * @param name     The identifier for this global declaration.
     */
    public GlobalDefinition(Position position, Identifier name) {
        super(position);
        this.name = name;
    }
}
