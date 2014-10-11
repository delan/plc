%{

#include <stdio.h>
#include <string.h>

int yydebug = 1;

void yyerror(const char *s) {
        fprintf(stderr, "parser: error: %s\n", s);
}

int yywrap(void) {
        return 1;
}

int main(void) {
        yyparse();
        return 0;
}

#define NONT(KIND) printf("parser: found " #KIND "\n");

%}

%token
        PL_ARRAY
        PL_BEGIN
        PL_CALL
        PL_CONST
        PL_DO
        PL_DECLARATION
        PL_END
        PL_FOR
        PL_FUNCTION
        PL_IF
        PL_IMPLEMENTATION
        PL_OF
        PL_PROCEDURE
        PL_THEN
        PL_TYPE
        PL_VAR
        PL_WHILE
        PL_COLON
        PL_SEMICOLON
        PL_COMMA
        PL_DOT
        PL_EQUALS
        PL_ASSIGN
        PL_ADD
        PL_SUBTRACT
        PL_MULTIPLY
        PL_DIVIDE
        PL_LSQUARE
        PL_RSQUARE
        PL_LCURLY
        PL_RCURLY
        PL_LPAREN
        PL_RPAREN
        PL_TO
        PL_NUMBER
        PL_IDENT

%%

basic_program : declaration_unit
              { NONT(basic_program) }
              | implementation_unit
              { NONT(basic_program) }
              ;

declaration_unit : PL_DECLARATION
                   PL_OF
                   PL_IDENT
                   optional_const_and_constant_declaration
                   optional_var_and_variable_declaration
                   optional_type_declaration
                   optional_procedure_interface
                   optional_function_interface
                   PL_DECLARATION
                   PL_END
                 { NONT(declaration_unit) }
                 ;

optional_const_and_constant_declaration :
                                        { NONT(optional_const_and_constant_declaration) }
                                        | PL_CONST
                                          constant_declaration
                                        { NONT(optional_const_and_constant_declaration) }
                                        ;

optional_var_and_variable_declaration :
                                      { NONT(optional_var_and_variable_declaration) }
                                      | PL_VAR
                                        variable_declaration
                                      { NONT(optional_var_and_variable_declaration) }
                                      ;

optional_type_declaration :
                          { NONT(optional_type_declaration) }
                          | type_declaration
                          { NONT(optional_type_declaration) }
                          ;

optional_procedure_interface :
                             { NONT(optional_procedure_interface) }
                             | procedure_interface
                             { NONT(optional_procedure_interface) }
                             ;

optional_function_interface :
                            { NONT(optional_function_interface) }
                            | function_interface
                            { NONT(optional_function_interface) }
                            ;

procedure_interface : PL_PROCEDURE
                      PL_IDENT
                      optional_formal_parameters
                    { NONT(procedure_interface) }
                    ;

function_interface : PL_FUNCTION
                     PL_IDENT
                     optional_formal_parameters
                   { NONT(function_interface) }
                   ;

optional_formal_parameters :
                           { NONT(optional_formal_parameters) }
                           | formal_parameters
                           { NONT(optional_formal_parameters) }
                           ;

type_declaration : PL_TYPE
                   PL_IDENT
                   PL_COLON
                   type
                   PL_SEMICOLON
                   { NONT(type_declaration) }
                 ;

formal_parameters : PL_LPAREN
                    semicolon_idents
                    PL_RPAREN
                  { NONT(formal_parameters) }
                  ;

semicolon_idents : PL_IDENT
                 { NONT(semicolon_idents) }
                 | semicolon_idents
                   PL_SEMICOLON
                   PL_IDENT
                 { NONT(semicolon_idents) }
                 ;

constant_declaration : comma_constant_declaration_fragments
                       PL_SEMICOLON
                     { NONT(constant_declaration) }
                     ;

comma_constant_declaration_fragments : constant_declaration_fragment
                                     { NONT(comma_constant_declaration_fragments) }
                                     | comma_constant_declaration_fragments
                                       PL_COMMA
                                       constant_declaration_fragment
                                     { NONT(comma_constant_declaration_fragments) }
                                     ;

constant_declaration_fragment : PL_IDENT
                                PL_EQUALS
                                PL_NUMBER
                              { NONT(constant_declaration_fragment) }
                              ;

variable_declaration : comma_variable_declaration_fragments
                       PL_SEMICOLON
                     { NONT(variable_declaration) }
                     ;

comma_variable_declaration_fragments : variable_declaration_fragment
                                     { NONT(comma_variable_declaration_fragments) }
                                     | comma_variable_declaration_fragments
                                       PL_COMMA
                                       variable_declaration_fragment
                                     { NONT(comma_variable_declaration_fragments) }
                                     ;

variable_declaration_fragment : PL_IDENT
                                PL_COLON
                                PL_IDENT
                              { NONT(variable_declaration_fragment) }
                              ;

type : basic_type
     { NONT(type) }
     | array_type
     { NONT(type) }
     ;

basic_type : PL_IDENT
           { NONT(basic_type) }
           | enumerated_type
           { NONT(basic_type) }
           | range_type
           { NONT(basic_type) }
           ;

enumerated_type : PL_LCURLY
                  comma_idents
                  PL_RCURLY
                { NONT(enumerated_type) }
                ;

comma_idents : PL_IDENT
             { NONT(comma_idents) }
             | comma_idents
               PL_COMMA
               PL_IDENT
             { NONT(comma_idents) }
             ;

range_type : PL_LSQUARE
             range
             PL_RSQUARE
           { NONT(range_type) }
           ;

array_type : PL_ARRAY
             PL_IDENT
             PL_LSQUARE
             range
             PL_RSQUARE
             PL_OF
             type
           { NONT(array_type) }
           ;

range : PL_NUMBER
        PL_TO
        PL_NUMBER
      { NONT(range) }
      ;

implementation_unit : PL_IMPLEMENTATION
                      PL_OF
                      PL_IDENT
                      block
                      PL_DOT
                    { NONT(implementation_unit) }
                    ;

block : specification_part
        implementation_part
      { NONT(block) }
      ;

specification_part :
                   { NONT(specification_part) }
                   | PL_CONST
                     constant_declaration
                   { NONT(specification_part) }
                   | PL_VAR
                     variable_declaration
                   { NONT(specification_part) }
                   | procedure_declaration
                   { NONT(specification_part) }
                   | function_declaration
                   { NONT(specification_part) }
                   ;

procedure_declaration : PL_PROCEDURE
                        PL_IDENT
                        PL_SEMICOLON
                        block
                        PL_SEMICOLON
                      { NONT(procedure_declaration) }
                      ;

function_declaration : PL_FUNCTION
                       PL_IDENT
                       PL_SEMICOLON
                       block
                       PL_SEMICOLON
                     { NONT(function_declaration) }
                     ;

implementation_part : statement
                    { NONT(implementation_part) }
                    ;

statement : assignment
          { NONT(statement) }
          | procedure_call
          { NONT(statement) }
          | if_statement
          { NONT(statement) }
          | while_statement
          { NONT(statement) }
          | do_statement
          { NONT(statement) }
          | for_statement
          { NONT(statement) }
          | compound_statement
          { NONT(statement) }
          ;

assignment : PL_IDENT
             PL_ASSIGN
             expression
           { NONT(assignment) }
           ;

procedure_call : PL_CALL
                 PL_IDENT
               { NONT(procedure_call) }
               ;

if_statement : PL_IF
               expression
               PL_THEN
               compound_statement_sequence
               PL_END
               PL_IF
             { NONT(if_statement) }
             ;

while_statement : PL_WHILE
                  expression
                  PL_DO
                  compound_statement_sequence
                  PL_END
                  PL_WHILE
                { NONT(while_statement) }
                ;

do_statement : PL_DO
               compound_statement_sequence
               PL_WHILE
               expression
               PL_END
               PL_DO
             { NONT(do_statement) }
             ;

for_statement : PL_FOR
                PL_IDENT
                PL_ASSIGN
                expression
                PL_DO
                compound_statement_sequence
                PL_END
                PL_FOR
              { NONT(for_statement) }
              ;

compound_statement : PL_BEGIN
                     compound_statement_sequence
                     PL_END
                   { NONT(compound_statement) }
                   ;

compound_statement_sequence : semicolon_statements
                            { NONT(compound_statement_sequence) }
                            ;

semicolon_statements : statement
                     { NONT(semicolon_statements) }
                     | semicolon_statements
                       PL_SEMICOLON
                       statement
                     { NONT(semicolon_statements) }
                     ;

expression : add_subtract_terms
           { NONT(expression) }
           ;

add_subtract_terms : term
                   { NONT(add_subtract_terms) }
                   | add_subtract_terms
                     PL_ADD
                     term
                   { NONT(add_subtract_terms) }
                   | add_subtract_terms
                     PL_SUBTRACT
                     term
                   { NONT(add_subtract_terms) }
                   ;

term : multiply_divide_id_nums
     { NONT(term) }
     ;

multiply_divide_id_nums : id_num
                        { NONT(multiply_divide_id_nums) }
                        | multiply_divide_id_nums
                          PL_MULTIPLY
                          id_num
                        { NONT(multiply_divide_id_nums) }
                        | multiply_divide_id_nums
                          PL_DIVIDE
                          id_num
                        { NONT(multiply_divide_id_nums) }
                        ;

id_num : PL_IDENT
       { NONT(id_num) }
       | PL_NUMBER
       { NONT(id_num) }
       ;
