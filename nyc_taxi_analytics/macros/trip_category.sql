{% macro trip_category(trip_distance) %}
    case 
        when {{ trip_distance }} < 1 then 'Short (<1 mile)'
        when {{ trip_distance }} between 1 and 5 then 'Medium (1-5 miles)' 
        when {{ trip_distance }} between 5 and 15 then 'Long (5-15 miles)'
        else 'Very Long (>15 miles)'
    end
{% endmacro %}