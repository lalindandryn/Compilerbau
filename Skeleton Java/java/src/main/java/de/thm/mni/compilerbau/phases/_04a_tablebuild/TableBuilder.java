package de.thm.mni.compilerbau.phases._04a_tablebuild;

import java.time.Year;
import java.util.ArrayList;
import java.util.List;
import de.thm.mni.compilerbau.CommandLineOptions;
import de.thm.mni.compilerbau.absyn.*;
import de.thm.mni.compilerbau.absyn.visitor.DoNothingVisitor;
import de.thm.mni.compilerbau.absyn.visitor.Visitor;
import de.thm.mni.compilerbau.table.*;
import de.thm.mni.compilerbau.types.ArrayType;
import de.thm.mni.compilerbau.types.PrimitiveType;
import de.thm.mni.compilerbau.types.Type;
import de.thm.mni.compilerbau.utils.NotImplemented;
import de.thm.mni.compilerbau.utils.SplError;

import javax.naming.Name;

/**
 * This class is used to create and populate a {@link SymbolTable} containing entries for every symbol in the currently
 * compiled SPL program.
 * Every declaration of the SPL program needs its corresponding entry in the {@link SymbolTable}.
 * <p>
 * Calculated {@link Type}s can be stored in and read from the dataType field of the {@link Expression},
 * {@link TypeExpression} or {@link Variable} classes.
 */
public class TableBuilder {
    private final CommandLineOptions options;

    public TableBuilder(CommandLineOptions options) {
        this.options = options;
    }

    private SymbolTable globalTable = new SymbolTable();//create new symbol table
    private SymbolTable localTable;
    private List<ParameterType> listOfParams;

    private Type dataType = null;
    private Type baseType = null;

    public SymbolTable buildSymbolTable(Program program) {
        //TODO (assignment 4a): Initialize a symbol table with all predefined symbols and fill it with user-defined symbols
        globalTable = TableInitializer.initializeGlobalTable();
        for(var globalDeclaration: program.definitions){
            switch (globalDeclaration){
                case ProcedureDefinition procedureDefinition -> {
                    //This answer is the closest/identic to eco32 for esp. file bigtest.spl

                    /*localTable = new SymbolTable(globalTable);
                    listOfParams = new ArrayList<>();
                    for(var parameter: procedureDefinition.parameters){
                        dataTypeSwitcher(parameter.typeExpression, localTable);
                        localTable.enter(parameter.name, new VariableEntry(dataType, parameter.isReference));
                        listOfParams.add(new ParameterType(dataType, parameter.isReference));
                    }

                    for(var variable: procedureDefinition.variables){
                        dataTypeSwitcher(variable.typeExpression, localTable);
                        localTable.enter(variable.name, new VariableEntry(dataType, false));
                    }

                    globalTable.enter(procedureDefinition.name, new ProcedureEntry(localTable, listOfParams));
                    printSymbolTableAtEndOfProcedure(procedureDefinition.name, new ProcedureEntry(localTable, listOfParams));*/
                }
                case TypeDefinition typeDefinition ->{
                    dataTypeSwitcher(typeDefinition.typeExpression, globalTable);
                    globalTable.enter(typeDefinition.name, new TypeEntry(dataType));
                }
            }
        }

        for(var globalDeclaration: program.definitions){
            // This answer is by the tutor expected one, but it has a bit diff to eco32.
            switch (globalDeclaration){
                case ProcedureDefinition procedureDefinition -> {
                    localTable = new SymbolTable(globalTable);
                    listOfParams = new ArrayList<>();
                    for(var parameter: procedureDefinition.parameters){
                        dataTypeSwitcher(parameter.typeExpression, localTable);
                        localTable.enter(parameter.name, new VariableEntry(dataType, parameter.isReference));
                        listOfParams.add(new ParameterType(dataType, parameter.isReference));
                    }

                    for(var variable: procedureDefinition.variables){
                        dataTypeSwitcher(variable.typeExpression, localTable);
                        localTable.enter(variable.name, new VariableEntry(dataType, false));
                    }

                    globalTable.enter(procedureDefinition.name, new ProcedureEntry(localTable, listOfParams));
                    if(this.options.phaseOption == CommandLineOptions.PhaseOption.TABLES) {
                        printSymbolTableAtEndOfProcedure(procedureDefinition.name, new ProcedureEntry(localTable, listOfParams));
                    }
                }
                case TypeDefinition typeDefinition -> {
                    //empty
                }
            }
        }

        return globalTable;
    }

    private Type dataTypeSwitcher(TypeExpression typeExpression, SymbolTable table){
        switch (typeExpression){
            case ArrayTypeExpression arrayTypeExpression -> {
                baseType = determineBaseType(arrayTypeExpression.baseType);
                dataType = new ArrayType(baseType, arrayTypeExpression.arraySize);
            }
            case NamedTypeExpression namedTypeExpression -> {
                Entry entry = table.lookup(namedTypeExpression.name);
                if(!(entry instanceof TypeEntry)){ //Error code 102
                    throw SplError.NotAType(namedTypeExpression.position, namedTypeExpression.name);
                }else if(entry != null){
                    dataType = ((TypeEntry) entry).type;
                }
            }
        }
        return  dataType;
    }

    private Type determineBaseType(TypeExpression baseType) {
        switch (baseType){
            case ArrayTypeExpression arrayTypeExpression -> {
                Type base = determineBaseType(arrayTypeExpression.baseType);
                return new ArrayType(base, arrayTypeExpression.arraySize);
            }
            case NamedTypeExpression namedTypeExpression -> {
                Entry entry = globalTable.lookup(namedTypeExpression.name);
                return ((TypeEntry) entry).type;
            }
        }
    }

    /**
     * Prints the local symbol table of a procedure together with a heading-line
     * NOTE: You have to call this after completing the local table to support '--tables'.
     *
     * @param name  The name of the procedure
     * @param entry The entry of the procedure to print
     */
    static void printSymbolTableAtEndOfProcedure(Identifier name, ProcedureEntry entry) {
        System.out.format("Symbol table at end of procedure '%s':\n", name);
        System.out.println(entry.localTable.toString());
    }
}
