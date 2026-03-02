(* mustache-yacc.mly *)
%{
  open TemplateAst
  exception Error of string
%}

%token <string> VARIABLE SECTION_START SECTION_END INVERTED_SECTION_START PARTIAL TEXT

%start main
%%

main:
  nodes = node_list { nodes }

node_list:
  nodes = node_list node { nodes @ [node] }
  | { [] }

node:
  TextNode
  | VariableNode
  | SectionNode
  | InvertedSectionNode
  | PartialNode

TextNode:
  TEXT { Text $1 }

VariableNode:
  VARIABLE { Variable $1 }

SectionNode:
  SECTION_START name=VARIABLE node_list SECTION_END { Section($2, $3) }

InvertedSectionNode:
  INVERTED_SECTION_START name=VARIABLE node_list { InvertedSection($2, $3) }

PartialNode:
  PARTIAL { Partial $1 }