package de.thm.mni.compilerbau.absyn;

import de.thm.mni.compilerbau.absyn.visitor.Visitor;

import java.util.List;

/**
 * This class represents the root of the AST.
 * <p>
 * A program in SPL consists of a list of global definitions ({@link TypeDefinition} and {@link ProcedureDefinition}).
 */
public class Program extends Node {
    public final List<GlobalDefinition> definitions;

    /**
     * Creates a new node representing the entire SPL program.
     *
     * @param position     The position of the SPL program in the source code. (This is usually the position of the first declaration)
     * @param definitions The list of global definitions in the SPL program.
     */
    public Program(Position position, List<GlobalDefinition> definitions) {
        super(position);
        this.definitions = definitions;
    }

    @Override
    public String toString() {
        return formatAst("Program", definitions.toArray());
    }

    @Override
    public void accept(Visitor visitor) {
        visitor.visit(this);
    }
}
