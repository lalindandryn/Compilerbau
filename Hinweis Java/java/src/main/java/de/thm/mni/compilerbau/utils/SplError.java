package de.thm.mni.compilerbau.utils;

import de.thm.mni.compilerbau.absyn.BinaryExpression;
import de.thm.mni.compilerbau.absyn.Position;
import de.thm.mni.compilerbau.absyn.UnaryExpression;
import de.thm.mni.compilerbau.table.Identifier;
import de.thm.mni.compilerbau.types.Type;

import java.util.List;
import java.util.stream.Collectors;

/**
 * An exception class, that encapsulates all possible SPL errors.
 * Contains static methods that construct exceptions for specific errors.
 */
public class SplError extends RuntimeException {
    public final Position position;
    public final int errorCode;

    private SplError(int errorCode, Position position, String message, Object... formatArgs) {
        super(String.format(message, formatArgs));
        this.errorCode = errorCode;
        this.position = position;
    }

    public static SplError LexicalError(Position position, char character) {
        return new SplError(99, position,
                Character.isISOControl(character) || Character.isWhitespace(character)
                        ? String.format("Lexical error: Unexpected character with ascii code 0x%s.", Integer.toString(character, 16))
                        : String.format("Lexical error: Unexpected character '%s'.", character));
    }

    public static SplError SyntaxError(Position position, String token, List<String> expectedTokens) {
        if (expectedTokens == null || expectedTokens.isEmpty())
            return new SplError(100, position, "Syntax error: Unexpected token '%s'.", token);
        else if (expectedTokens.size() == 1)
            return new SplError(100, position, "Syntax error: Unexpected token '%s'. Expected token '%s' instead.", token, expectedTokens.get(0));
        else
            return new SplError(100, position, "Syntax error: Unexpected token '%s'. Expected one of [%s] instead.", token, String.join(", ", expectedTokens.stream().sorted().toList()));
    }

    public static SplError UndefinedIdentifier(Position position, Identifier name) {
        return new SplError(101, position, "Identifier '%s' is not defined.", name);
    }

    public static SplError NotAType(Position position, Identifier name) {
        return new SplError(102, position, "Identifier '%s' does not refer to a type.", name);
    }

    public static SplError RedefinitionOfIdentifier(Position position, Identifier name) {
        return new SplError(103, position, "Identifier '%s' is already defined in this scope.", name);
    }

    public static SplError ParameterMustBeReference(Position position, Identifier name, Type type) {
        return new SplError(104, position, "Non-reference parameter '%s' has type '%s', which can only be passed by reference.", name, type);
    }

    public static SplError IllegalAssignment(Position position, Type variableType, Type valueType) {
        return new SplError(108, position, "A value of type '%s' can not be assigned to variable of type '%s'.", valueType, variableType);
    }

    public static SplError IfConditionMustBeBoolean(Position position, Type actual) {
        return new SplError(110, position, "'if' condition expected to be of type 'boolean', but is of type '%s'.", actual);
    }

    public static SplError WhileConditionMustBeBoolean(Position position, Type actual) {
        return new SplError(111, position, "'while' condition expected to be of type 'boolean', but is of type '%s'.", actual);
    }

    public static SplError CallOfNonProcedure(Position position, Identifier name) {
        return new SplError(113, position, "Identifier '%s' does not refer to a procedure.", name);
    }

    public static SplError ArgumentTypeMismatch(Position position, Identifier name, int argumentIndex, Type expected, Type actual) {
        return new SplError(114, position, "Argument type mismatch in call of procedure '%s'. Argument %d is expected to have type '%s', but has type '%s'.", name, argumentIndex, expected, actual);
    }

    public static SplError ArgumentMustBeAVariable(Position position, Identifier name, int argumentIndex) {
        return new SplError(115, position, "Invalid argument for reference parameter in call to procedure '%s': Argument %d must be a variable.", name, argumentIndex);
    }

    public static SplError ArgumentCountMismatch(Position position, Identifier name, int expected, int actual) {
        if (actual < expected)
            return new SplError(116, position, "Argument count mismatch: Procedure '%s' expects %d arguments, but only %d were provided.", name, expected, actual);
        else
            return new SplError(116, position, "Argument count mismatch: Procedure '%s' expects only %d arguments, but %d were provided.", name, expected, actual);
    }

    public static SplError OperandTypeMismatch(Position position, BinaryExpression.Operator operator, Type leftType, Type rightType) {
        return new SplError(118, position, "Type mismatch in binary expression: Operator '%s' does not accept operands of types '%s' and '%s'.", operator.operatorString(), leftType, rightType);
    }

    public static SplError OperandTypeMismatch(Position position, UnaryExpression.Operator operator, Type rightType) {
        return new SplError(119, position, "Type mismatch in unary expression: Operator '%s' does not accept operand of type '%s'.", operator.operatorString(), rightType);
    }

    public static SplError NotAVariable(Position position, Identifier name) {
        return new SplError(122, position, "Identifier '%s' does not refer to a variable.", name);
    }

    public static SplError IndexingNonArray(Position position, Type actual) {
        return new SplError(123, position, "Type mismatch: Invalid array access operation on non-array variable of type '%s'.", actual);
    }

    public static SplError IndexTypeMismatch(Position position, Type actual) {
        return new SplError(124, position, "Type mismatch: Array index expected to be of type 'int', but is type '%s'.", actual);
    }

    public static SplError MainIsMissing() {
        return new SplError(125, Position.ERROR_POSITION, "Procedure 'main' is missing.");
    }

    public static SplError MainIsNotAProcedure() {
        return new SplError(126, Position.ERROR_POSITION, "Identifier 'main' does not refer to a procedure.");
    }

    public static SplError MainMustNotHaveParameters() {
        return new SplError(127, Position.ERROR_POSITION, "Procedure 'main' must not have any parameters.");
    }

    public static SplError RegisterOverflow() {
        return new SplError(140, Position.ERROR_POSITION, "There are not enough registers to run this program!");
    }
}
