parser grammar ConnectorParser;

options
   { tokenVocab = ConnectorLexer; }

stat
   : insert_from_clause|select_clause
   ;

into
   : INTO
   ;

pk
   : PK
   ;

insert_into
   : INSERT into
   ;

upsert_into
   : UPSERT into
   ;

upsert_pk_into
   : ( UPSERT pk FIELD into)
   ;

write_mode
   : insert_into | upsert_into | upsert_pk_into
   ;

insert_from_clause
   : write_mode table_name select_clause_basic ( autocreate )? (with_structure)? ( PK primary_key_list)? (with_target)? ( autoevolve )? ( batching )?
    (partitionby)? (timestamp_clause)? (timestamp_unit_clause)?
    ( with_format_clause )? (with_unwrap_clause)? (storeas_clause)? (with_tags)? (with_inc_mode)? (with_type)? (with_doc_type)? (with_index_suffix)?
    (ttl_clause)? (with_converter)? (with_jms_selector)? (with_key)? (key_delimiter)? (with_pipeline_clause)?
    (with_subscription_clause)? (with_regex_clause)?
    (limit_clause)?
    (properties_clause)?
   ;

select_clause
   : select_clause_basic ( PK primary_key_list)? (with_structure)? (with_format_clause)? (with_unwrap_clause)? (limit_clause)? (storeas_clause)? (with_tags)? (with_inc_mode)? (with_doc_type)? (with_index_suffix)? (with_converter)? (key_delimiter)? (ttl_clause)?
   ;

select_clause_basic
   : SELECT column_list FROM topic_name ( with_ignore )?
   ;

topic_name
   : ( FIELD | TOPICNAME | DOT )+ | STRING
   ;

table_name
   : ( FIELD | TOPICNAME | DOT )+ | STRING
   ;

column_name
   : column ( AS column_name_alias )? | ASTERISK
   ;

column
   : FIELD ( DOT FIELD )* (DOT ASTERISK)? | STRING
   ;

partition_column
   : (field_or_quoted_field ( DOT field_or_quoted_field )* (DOT ASTERISK)?) | STRING
   ;

field_or_quoted_field
   : ((ESCAPED_FIELD | FIELD)* DOT*)
   ;

column_name_alias
   : FIELD | STRING
   ;

column_list
   : column_name ( COMMA column_name )*
   ;

from_clause
   : FROM table_name
   ;

with_ignore
   : IGNORE ignore_clause
   ;

ignore_clause
   : column_name ( COMMA column_name )*
   ;

pk_name
   : column
   ;

primary_key_list
   : pk_name ( COMMA pk_name )*
   ;

autocreate
   : AUTOCREATE
   ;

autoevolve
   : AUTOEVOLVE
   ;

batch_size
    : INT
    ;

batching
   : BATCH EQUAL batch_size
   ;

partition_name
   : partition_column
   ;

partition_list
   : partition_name ( COMMA partition_name)*
   ;

partitionby
   : NOPARTITION | PARTITIONBY partition_list
   ;

timestamp_clause
   : TIMESTAMP timestamp_value
   ;

timestamp_value
   : FIELD | SYS_TIME
   ;

timestamp_unit_clause
   : TIMESTAMPUNIT EQUAL timestamp_unit_value
   ;

timestamp_unit_value
   : FIELD
   ;

limit_clause
    : LIMIT limit_value
    ;

limit_value
    : INT
    ;

with_unwrap_clause
    : WITHUNWRAP
    ;

with_format_clause
    : WITHFORMAT with_format
    ;

with_structure
    : WITHSTRUCTURE
    ;

with_format
    : FIELD
    ;

properties_clause
    : PROPERTIES LEFT_PARAN ()properties_list RIGHT_PARAN
    ;

// allow empty or list of key=value pairs
properties_list
    : (property (COMMA property)*)?
    ;

 property
    : property_name EQUAL property_value
    ;

property_name
    : FIELD | ( DOT | TOPICNAME )+ | STRING
    ;

property_value
    : FIELD | (DOT|TOPICNAME)+ | INT | STRING
    ;

storeas_clause
    : STOREAS storeas_type (storeas_parameters)*
    ;

storeas_type
    : FIELD | ( DOT | TOPICNAME )+
    ;

storeas_parameters
    : (LEFT_PARAN storeas_parameters_tuple ( COMMA storeas_parameters_tuple)* RIGHT_PARAN)
    ;


storeas_parameters_tuple
    :  storeas_parameter EQUAL storeas_value
    ;

storeas_parameter
    : FIELD | ( DOT | TOPICNAME )+
    ;

storeas_value
    : FIELD | (DOT|TOPICNAME)+ | INT
    ;

with_tags
    : WITHTAG (LEFT_PARAN tag_definition ( COMMA tag_definition )* RIGHT_PARAN)
    ;

with_key
    : WITHKEY (LEFT_PARAN with_key_value (COMMA with_key_value)* RIGHT_PARAN)
    ;

with_key_value
    : FIELD | TOPICNAME | INT
    ;

key_delimiter
    : KEYDELIM  EQUAL key_delimiter_value
    ;

key_delimiter_value
    : KEYDELIMVALUE
    ;

with_inc_mode
    : INCREMENTALMODE EQUAL inc_mode
    ;

inc_mode
    : FIELD | TOPICNAME
    ;

with_type
    : WITHTYPE with_type_value
    ;


with_type_value
    : FIELD
    ;

with_doc_type
    : WITHDOCTYPE EQUAL doc_type
    ;

doc_type
    : FIELD | TOPICNAME | INT
    ;

with_index_suffix
    : WITHINDEXSUFFIX EQUAL index_suffix
    ;

index_suffix
    : FIELD | TOPICNAME | INT
    ;

with_converter
    : WITHCONVERTER EQUAL with_converter_value
    ;

with_converter_value
    : ID | TOPICNAME
    ;

with_target
    : WITHTARGET EQUAL with_target_value
    ;

with_target_value
    : (FIELD|DOT)+ | (DOT|TOPICNAME)+
    ;

with_jms_selector
    : WITHJMSSELECTOR EQUAL jms_selector_value
    ;

jms_selector_value
   : ID | TOPICNAME
   ;

tag_definition
    : tag_key ( (EQUAL tag_value)| (AS tag_value))?
    ;

tag_key
    : (FIELD|DOT)+ | (DOT|TOPICNAME)+
    ;

tag_value
    : FIELD | (DOT|TOPICNAME)+ | INT
    ;


ttl_clause
    : TTL EQUAL ttl_type
    ;

ttl_type
    : INT
    ;

with_pipeline_clause
    : WITHPIPELINE EQUAL pipeline_value
    ;

pipeline_value
    :  (FIELD | (DOT|TOPICNAME)+ | INT)+
    ;

with_subscription_clause
   : WITHSUBSCRIPTION EQUAL with_subscription_value
   ;

with_subscription_value
   : FIELD
   ;

with_regex_clause
    : WITHREGEX EQUAL with_regex_value
    ;

with_regex_value
    : ID | TOPICNAME
    ;
