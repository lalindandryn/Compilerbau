package de.thm.mni.compilerbau.absyn;

import de.thm.mni.compilerbau.absyn.visitor.Visitor;
import de.thm.mni.compilerbau.table.Identifier;

/**
 * This class represents the declaration of a type in SPL.
 * <p>
 * When declaring a type, you have to provide a name, which is used as the identifier of this declaration.
 * Additionally a {@link TypeExpression} has to be provided, which stands on the right hand side of the declaration.
 */
final public class TypeDefinition extends GlobalDefinition {
    public final TypeExpression typeExpression;

    /**
     * Creates a new node representing a type declaration.
     *
     * @param position       The position of the declaration in the source code.
     * @param name           The definitions identifier.
     * @param typeExpression The type expression associated with this declaration.
     */
    public TypeDefinition(Position position, Identifier name, TypeExpression typeExpression) {
        super(position, name);
        this.typeExpression = typeExpression;
    }

    @Override
    public String toString() {
        return formatAst("TypeDefinition", name, typeExpression);
    }

    @Override
    public void accept(Visitor visitor) {
        visitor.visit(this);
    }
}
