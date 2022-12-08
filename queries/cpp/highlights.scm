;; extends

;; "not"
((type_identifier) @operator (#any-of? @operator "not"))
((identifier) @operator (#any-of? @operator "not"))

;; "and", "or"
((identifier) @operator (#any-of? @operator "and" "or"))
