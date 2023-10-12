package de.thm.mni.compilerbau.table;

import de.thm.mni.compilerbau.types.Type;

/**
 * Represents the table entry for type-definitions in SPL.
 */
public class TypeEntry implements Entry {
    public final Type type;

    /**
     * Creates a new {@link Entry} representing a declared SPL {@link Type}.
     *
     * @param type The "meaning" of the type definition.
     *             Determined by the type expression on the right of the type definition.
     *             See {@link Type} and its subclasses.
     */
    public TypeEntry(Type type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return String.format("type: %s", type);
    }
}
