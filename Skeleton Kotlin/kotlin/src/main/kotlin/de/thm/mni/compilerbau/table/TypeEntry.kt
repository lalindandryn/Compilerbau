package de.thm.mni.compilerbau.table

import de.thm.mni.compilerbau.types.Type

/**
 * Represents the table entry for type-definitions in SPL.
 *
 * @param type The "meaning" of the type definition.
 *             Determined by the type expression on the right of the type definition.
 *             See [Type] and its subclasses.
 */
class TypeEntry(val type: Type) : Entry {
    override fun toString() = "type: $type"
}
