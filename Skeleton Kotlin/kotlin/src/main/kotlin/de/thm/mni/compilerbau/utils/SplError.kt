package de.thm.mni.compilerbau.utils

import de.thm.mni.compilerbau.absyn.BinaryExpression
import de.thm.mni.compilerbau.absyn.Position
import de.thm.mni.compilerbau.absyn.UnaryExpression
import de.thm.mni.compilerbau.table.Identifier
import de.thm.mni.compilerbau.types.Type
import java.util.stream.Collectors

/**
 * An exception class, that encapsulates all possible SPL errors.
 * Contains static methods that construct exceptions for specific errors.
 */
class SplError private constructor(val errorCode: Int, val position: Position, message: String, vararg formatArgs: Any) : RuntimeException(String.format(message, *formatArgs)) {
    companion object {
        @JvmStatic
        fun LexicalError(position: Position, character: Char): SplError {
            return SplError(99, position,
                if (Character.isISOControl(character) || Character.isWhitespace(character))
                    String.format("Lexical error: Unexpected character with ascii code 0x%s.", character.code.toString(16))
                else
                    String.format("Lexical error: Unexpected character '%s'.", character))
        }

        @JvmStatic
        fun SyntaxError(position: Position, token: String?, expectedTokens: List<String>?): SplError {
            return if (expectedTokens.isNullOrEmpty())
                SplError(100, position, "Syntax error: Unexpected token '%s'.", token!!)
            else if (expectedTokens.size == 1)
                SplError(100, position, "Syntax error: Unexpected token '%s'. Expected token '%s' instead.", token!!, expectedTokens[0])
            else
                SplError(100, position, "Syntax error: Unexpected token '%s'. Expected one of [%s] instead.", token!!, expectedTokens.sorted().joinToString(", "))
        }

        fun UndefinedIdentifier(position: Position, name: Identifier): SplError {
            return SplError(101, position, "Identifier '%s' is not defined.", name)
        }

        fun NotAType(position: Position, name: Identifier): SplError {
            return SplError(102, position, "Identifier '%s' does not refer to a type.", name)
        }

        fun RedefinitionOfIdentifier(position: Position, name: Identifier): SplError {
            return SplError(103, position, "Identifier '%s' is already defined in this scope.", name)
        }

        fun ParameterMustBeReference(position: Position, name: Identifier, type: Type?): SplError {
            return SplError(104, position, "Non-reference parameter '%s' has type '%s', which can only be passed by reference.", name, type!!)
        }

        fun IllegalAssignment(position: Position, variableType: Type?, valueType: Type?): SplError {
            return SplError(108, position, "A value of type '%s' can not be assigned to variable of type '%s'.", valueType!!, variableType!!)
        }

        fun IfConditionMustBeBoolean(position: Position, actual: Type?): SplError {
            return SplError(110, position, "'if' condition expected to be of type 'boolean', but is of type '%s'.", actual!!)
        }

        fun WhileConditionMustBeBoolean(position: Position, actual: Type?): SplError {
            return SplError(111, position, "'while' condition expected to be of type 'boolean', but is of type '%s'.", actual!!)
        }

        fun CallOfNonProcedure(position: Position, name: Identifier): SplError {
            return SplError(113, position, "Identifier '%s' does not refer to a procedure.", name)
        }

        fun ArgumentTypeMismatch(position: Position, name: Identifier, argumentIndex: Int, expected: Type?, actual: Type?): SplError {
            return SplError(114, position, "Argument type mismatch in call of procedure '%s'. Argument %d is expected to have type '%s', but has type '%s'.",
                name, argumentIndex, expected!!, actual!!)
        }

        fun ArgumentMustBeAVariable(position: Position, name: Identifier, argumentIndex: Int): SplError {
            return SplError(115, position, "Invalid argument for reference parameter in call to procedure '%s': Argument %d must be a variable.", name, argumentIndex)
        }

        fun ArgumentCountMismatch(position: Position, name: Identifier, expected: Int, actual: Int): SplError {
            return if (actual < expected) SplError(116, position, "Argument count mismatch: Procedure '%s' expects %d arguments, but only %d were provided.", name, expected, actual) else SplError(116, position, "Argument count mismatch: Procedure '%s' expects only %d arguments, but %d were provided.",
                name, expected, actual)
        }

        fun OperandTypeMismatch(position: Position, operator: BinaryExpression.Operator, leftType: Type?, rightType: Type?): SplError {
            return SplError(118, position, "Type mismatch in binary expression: Operator '%s' does not accept operands of types '%s' and '%s'.", operator.operatorString(), leftType!!, rightType!!)
        }

        fun OperandTypeMismatch(position: Position, operator: UnaryExpression.Operator, rightType: Type?): SplError {
            return SplError(119, position, "Type mismatch in unary expression: Operator '%s' does not accept operand of type '%s'.", operator.operatorString(), rightType!!)
        }

        fun NotAVariable(position: Position, name: Identifier): SplError {
            return SplError(122, position, "Identifier '%s' does not refer to a variable.", name)
        }

        fun IndexingNonArray(position: Position, actual: Type?): SplError {
            return SplError(123, position, "Type mismatch: Invalid array access operation on non-array variable of type '%s'.", actual!!)
        }

        fun IndexTypeMismatch(position: Position, actual: Type?): SplError {
            return SplError(124, position, "Type mismatch: Array index expected to be of type 'int', but is type '%s'.", actual!!)
        }

        fun MainIsMissing(): SplError {
            return SplError(125, Position.ERROR_POSITION, "Procedure 'main' is missing.")
        }

        fun MainIsNotAProcedure(): SplError {
            return SplError(126, Position.ERROR_POSITION, "Identifier 'main' does not refer to a procedure.")
        }

        fun MainMustNotHaveParameters(): SplError {
            return SplError(127, Position.ERROR_POSITION, "Procedure 'main' must not have any parameters.")
        }

        fun AccessingMemberOfNonRecord(position: Position): SplError {
            return SplError(128, position, "Type mismatch: Invalid member access operation on non-record variable of type '%s'.")
        }

        fun RecordMemberNotFound(position: Position, name: Identifier): SplError {
            return SplError(129, position, "Type mismatch: Record type does not have member with name '%s'.", name)
        }

        fun ArrayLiteralInconsistentTypes(position: Position): SplError {
            return SplError(131, position, "Type mismatch: Contents of array literal have inconsistent types.")
        }

        fun RegisterOverflow(): SplError {
            return SplError(140, Position.ERROR_POSITION, "There are not enough registers to run this program!")
        }
    }
}
