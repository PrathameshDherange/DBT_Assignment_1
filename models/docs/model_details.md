{% docs t1 %}
This table is Append mode: where whatever is coming from source is insert to target (this) table
{% enddocs %}
{% docs t2 %}
Data is inserted into this table only if key is not present in target (this) table.
{% enddocs %}
{% docs t3 %}
SCD Type 1 Table - Logic : Only key based logic - if key is present then update else insert into target table
{% enddocs %}
{% docs t4 %}
SCD Type 1 Table - Logic : key + hashkey - if key is present then compare the rest of the data and if it is not the same then update else ignore. If the key is not present then insert.
{% enddocs %}
{% docs t5 %}
SCD Type 2 Table - Logic : if key is present - close the existing record and then insert the new record for the same key. If the key is not present then insert.
{% enddocs %}
{% docs t6 %}
SCD Type 2 Table - Logic : key + hashkey - comparing the rest of the data and making the decision of insert, update or ignore.
{% enddocs %}
{% docs dept_details %}
Department details table is loaded based on csv (present in seeds).
{% enddocs %}

