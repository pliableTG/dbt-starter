-- This file was automatically generated by PLIABLE (https://app.pliable.co). 
-- Please do not edit this file directly, as it will be overwritten the next time someone commits their changes in Pliable.

{{ config(materialized="table") }}

select
    'plb:::m:file_upload_test_ahrefs::r:' || sha1(
        ifnull("Keywords"::string, '')
        || ifnull("Referring domains"::string, '')
        || ifnull("Referring page URL"::string, '')
        || ifnull("Referring page title"::string, '')
        || ifnull("Target URL"::string, '')
    ) as _plb_uuid,
    current_timestamp() as _plb_loaded_at
    {% for col in adapter.get_columns_in_relation(
        adapter.get_relation(
            database="DBT_PLIABLE_DATA_DB",
            schema="PROD_SOURCE",
            identifier="s_663121821efd5175ce68478a_flattened",
        )
    ) -%}, trim("{{col.column}}"::string) as "{{col.column}}" {% endfor %}
from prod_source.s_663121821efd5175ce68478a_flattened
where 1 = 1
-- Make sure there is only one record per _plb_uuid, using the user-supplied composite
-- key.
qualify row_number() over (partition by _plb_uuid order by _plb_loaded_at desc) = 1
